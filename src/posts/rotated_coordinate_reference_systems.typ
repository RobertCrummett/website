#import "../theme.typ": hr

Prospect scale surveys are laid out relative to geology, not geography. Most
survey grids end up rotated with resepct to true north. Processing is easier in
a survey-aligned frame. Line-based filters such as decorrugation and
microlevelling expect the lines to run along a grid axis. Directional
derivatives along and across strike become plain $x$ and $y$ derivatives. A
rectangular block wastes no padding in an FFT.

There is no "rotated UTM" in the EPSG registry, and GIS software cannot rotate
a projected CRS for you. The standard workaround is the
_Hotine Oblique Mercator_ projection (EPSG method 9815, "variant B"). It is a
conformal projection with two angles: one that rotates the projection and one
that rotates the grid. This post explains the two angles, shows how to build
the CRS on the command line with PROJ, and lists the traps I fell into.

#hr

= The Two Angles

Hotine first projects the ellipsoid onto a cylinder that touches the earth
along a great-circle-like _initial line_. The initial line passes through the
projection center $(phi_c, lambda_c)$ at azimuth $alpha_c$. Scale is true
along this line. The projection first produces skew coordinates $(u, v)$, with
$u$ along the initial line and $v$ 90° clockwise from it. These are then
_rectified_ into eastings and northings by a plane rotation through
$gamma_c$ [1]:

$
E &= v cos gamma_c + u sin gamma_c + E_c \
N &= u cos gamma_c - v sin gamma_c + N_c
$

The two parameters therefore do different jobs:

- `+alpha` ($alpha_c$, Azimuth of initial line) is a projection choice.
  It sets where the scale is true, so it controls distortion.
- `+gamma` ($gamma_c$, Angle from Rectified to Skew Grid) is a grid choice.
  It rotates the final $(E, N)$ axes in the plane and has no effect on
  distortion.

Setting $gamma_c = 0$ gives $N = u$, so grid north lies along the initial line.
Setting $gamma_c = alpha_c$ rotates grid north back onto true north at the
projection center [1]. This is the default PROJ uses when `+gamma` is
omitted [2], and it is how national grids such as Alaska zone 1 are
defined. Grid north at the center therefore has azimuth

$ theta = alpha_c - gamma_c. $

By default, $alpha_c = gamma_c$. In practice, choose $theta$ to be the survey
grid orientation, and $alpha_c$ to control the distortion.

== Which $alpha$ to choose

For prospect scale work the choice hardly matters. With `+k=1` and the center
on the survey, the point scale factor 50 km off the initial line is about
$1 + d^2 slash 2R^2 approx 1.00003$, or 30 ppm. That is 3 mm across a 100 m
cell. In the example below, a 20 km step along the initial line maps to
exactly 20,000.00 m. A 20 km step perpendicular to it maps to 20,000.03 m.

$alpha_c$ starts to matter when the survey is long and narrow, such as a
regional strip or a corridor several hundred kilometres long. In that case run
the initial line down the long axis. Hotine's construction itself starts to
break down several hundred kilometres from the center along the initial line
[1]. Beyond that, use a different projection or several blocks.

Setting $alpha_c = 0$ makes the initial line a meridian, so the projection is
transverse Mercator. With PROJ 9.4, `+proj=omerc +alpha=0 +gamma=0` centered
on my test survey agreed with `+proj=tmerc` on the same center to 0.1 mm at
50 km. So `+alpha=0 +gamma=-theta` is effectively "transverse Mercator centered
on the survey, rotated by $theta$". Easy to explain to colleagues.

= Traps

*Keep $alpha$ in $[-90°, 90°]$.* The formulas use
$gamma_0 = arcsin(sin alpha_c slash D)$ [1]. Because arcsin only returns
values in $[-90°, 90°]$, an azimuth outside that range is folded back into it.
In my tests with PROJ 9.4 and 9.6, `+alpha=120` gave exactly the same projection as
`+alpha=60`, with true scale along the 60° line rather than the 120° line,
and PROJ gave no warning. A line has two azimuths, so use the equivalent
value $alpha - 180°$: here, `+alpha=-60`.

*Center the projection on the survey.* You might try to imitate UTM by
placing the center at the zone's origin (latitude 0, central meridian,
`+alpha=0`, `+k=0.9996`) and then rotating. Because Hotine passes through an
intermediate sphere fitted at the center, this only matches UTM near the
equator. At 10° S, my test differed from UTM by about 0.1 ppm in scale. At
40.5° N, the coordinates were off by about 250 m, and the scale factor was
0.99938 instead of UTM's 0.99965, a 270 ppm difference. Put `+lat_0` and
`+lonc` in the middle of the block.

*`+no_rot` means "no rectification", not "no rotation"* [2]. It
returns the raw $(u, v)$ skew coordinates. Almost never useful.

*`+no_off` switches to variant A* [2]. In variant A the false easting and
northing are given at the natural origin, where the initial line crosses the
equator of the intermediate sphere. That point can be thousands of kilometers
away. Variant B, the default, puts $(E_c, N_c)$ at the projection center, which
is what you want.

*The scale factor.* `+k=1` makes distances true at the center. A UTM grid is not
true scale. At my test center, 63 km east of the central meridian, UTM's point
scale factor is 0.99965, a 350 ppm difference, or about 17 m over 50 km. If the
rotated coordinates must match an existing UTM dataset in scale, set `+k` to
UTM's point scale factor at the center. You can read it from `proj -V` (see
below).

= Building One on the Command Line

Everything below uses the PROJ command-line tools (`cs2cs`, `projinfo`,
`proj`, `geod`) and GDAL. The survey is invented: a block in UTM zone 11N
(EPSG:32611) centerd at 563,550 E, 4,483,525 N, with flight lines at 120° and
tie lines at 30°. I tested the commands with PROJ 9.4 and 9.6 and GDAL 3.10.
On Windows, QGIS ships all of these tools: open the _OSGeo4W Shell_ that
comes with it. The snippets use POSIX shell syntax, so translate the
variables and pipes if you run them in `cmd`.

== 1. Find the center in latitude and longitude

```sh
echo "563550.68 4483524.87" | cs2cs -d 6 EPSG:32611 EPSG:4326
# 40.500000  -116.250000   (lat lon!)
```

== 2. Write the PROJ string

Use $theta = 30°$ and the transverse Mercator form ($alpha_c = 0$, so
$gamma_c = -30°$). Choose a false origin at the center that keeps every
coordinate positive and cannot be mistaken for UTM:

```sh
OMERC="+proj=omerc +lat_0=40.5 +lonc=-116.25 +alpha=0 +gamma=-30 +k=1 +x_0=500000 +y_0=1000000 +datum=WGS84 +units=m +no_defs +type=crs"
```

== 3. Check the axes before trusting it

Use `geod` to step 20 km from the center along the flight-line and tie-line
azimuths, then project those points. A flight-line step should change only
$x$, and a tie-line step only $y$:

```sh
printf "40.5 -116.25 120 20000\n40.5 -116.25 30 20000\n" \
  | geod +ellps=WGS84 -f %.8f | awk '{print $2, $1}' \
  | cs2cs -d 2 +proj=longlat +datum=WGS84 +to $OMERC
# 520000.02  999999.99    <- along flight lines: x only
# 499999.99  1020000.01   <- along tie lines:    y only
```

(`$OMERC` is left unquoted on purpose: with `+to`, each `+` parameter has to
be a separate argument.)

`proj -V` reports the scale factor and convergence at any point:

```sh
echo "-116.0 40.7" | proj -V $OMERC
# ...
# Meridian scale (h) : 1.00000549
# Convergence : 30d9'46.891" [ 30.16302521 ]
```

== 4. Export WKT

Most GIS software prefers WKT. Ask `projinfo` for WKT2 for QGIS and GDAL,
and for ESRI WKT1 if you need a shapefile `.prj` that ArcGIS reads:

```sh
projinfo -q -o WKT2_2019 "$OMERC" > survey.wkt
projinfo -q -o WKT1_ESRI "$OMERC" > survey.prj
# GDAL equivalent: gdalsrsinfo -o wkt_esri survey.wkt
```

The WKT2 output names the method and both angles explicitly:

```text
METHOD["Hotine Oblique Mercator (variant B)", ID["EPSG",9815]],
PARAMETER["Latitude of projection center",40.5, ...],
PARAMETER["Longitude of projection center",-116.25, ...],
PARAMETER["Azimuth of initial line",0, ...],
PARAMETER["Angle from Rectified to Skew Grid",-30, ...],
PARAMETER["Scale factor on initial line",1, ...],
PARAMETER["Easting at projection center",500000, ...],
PARAMETER["Northing at projection center",1000000, ...]
```

ESRI calls the same thing `Rectified_Skew_Orthomorphic_Center` and calls
$gamma_c$ `XY_Plane_Rotation`:

```text
PROJECTION["Rectified_Skew_Orthomorphic_Center"],
PARAMETER["False_Easting",500000.0],PARAMETER["False_Northing",1000000.0],
PARAMETER["Scale_Factor",1.0],PARAMETER["Azimuth",0.0],
PARAMETER["Longitude_Of_Center",-116.25],PARAMETER["Latitude_Of_Center",40.5],
PARAMETER["XY_Plane_Rotation",-30.0]
```

== 5. Move data into it

```sh
# point / line data (x y z), from UTM
cs2cs -d 2 EPSG:32611 "$(cat survey.wkt)" < lines_utm.xyz > lines_rot.xyz

# vectors
ogr2ogr -t_srs survey.wkt outline_rot.shp outline_utm.shp

# rasters
gdalwarp -t_srs survey.wkt -tr 100 100 -r bilinear tmi_utm.tif tmi_rot.tif
```

`cs2cs` accepts a WKT string but not a file name, hence the
`"$(cat survey.wkt)"` [3].

== 6. Register it in QGIS

Open _Settings › Custom Projections_, choose WKT as the format, paste the
contents of `survey.wkt`, and click _Validate_. QGIS recommends storing
custom definitions as WKT rather than PROJ strings [4]. The CRS is saved
in your QGIS user database, not in the project, so send the `.wkt` file
along with the data when you share it. Then restart QGIS.

= Miscellaneous Remarks

Magnetic declination is measured from true north. Reduction to the pole and
other inclination/declination-dependent filters need the declination relative
to the grid $y$ axis,

$ D_"grid" = D_"true" - c, $

where $c$ is the convergence (the azimuth of grid north) reported by
`proj -V`. In a grid rotated by $theta$, $c approx theta$ at the center, so a
declination of $+11°$ becomes $11° - 30° = -19°$ in the example. Inclination
does not change. UTM has convergence too (0.49° at my test center), so the
same correction applies, just smaller.

Survey reports often give flight-line directions in UTM grid azimuth, not true
azimuth. At 0.49° convergence, a line at 120° grid is at about 120.5° true. Over
a 20 km line the difference is about 170 m sideways.

Running `gdalwarp` on an existing UTM grid interpolates it a second time and
smooths short wavelengths. Where you can, transform the located line data (step
5) and grid it directly in the rotated CRS.

#hr

= References

+ IOGP, _Geomatics Guidance Note 7, part 2: Coordinate Conversions and
  Transformations including Formulas_, Publication 373-7-2, §3.2.4 Oblique
  Mercator.
  #link("https://www.iogp.org/bookstore/product/coordinate-conversions-and-transformation-including-formulas/")[iogp.org]
+ PROJ documentation, _Oblique Mercator_.
  #link("https://proj.org/en/stable/operations/projections/omerc.html")[proj.org]
+ PROJ documentation, _cs2cs_.
  #link("https://proj.org/en/stable/apps/cs2cs.html")[proj.org]
