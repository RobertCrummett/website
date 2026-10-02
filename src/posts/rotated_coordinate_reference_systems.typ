In prospect scale geophysics, surveys are usually conducted with respect
to geologic trends, not geographic reference points. For instance,
total-field anomaly surveys at low magnetic latitudes flights will often
be flown north to south (magnetically). This will usually be within a
couple of degrees of geographic north. But if potentially significant
geologic trends are recognized in the region, flight lines may be
reoriented perpendicular to the strike of these features. Much prospect
scale scale work end up naturally rotated with respect to geographic north.

However, most coordinate reference systems are naturally oriented with
respect to geographic reference points. This creates friction between
'global' and 'survey-local' coordinate systems. We would prefer to do
post processing in a survey-local coordinate reference system for many
reasons, but out of the box most GIS software does not come with our
desired grid local coordinate system. This is an issue for integrating
our post processing routines for local work with existing projects.

Usually the difference between the local and global coordinate
transforms can be simply described by an affine transformation and
transformations between other supported coordinate reference systems.
So the trick to create a coordiante reference system will come down
to encoding this affine transformation in a way GIS programs will
understand. Here I provide example proj and WKT format coordinate
reference systems that do this in different scenarios.

The case I will cover here is translating between supported
projected coordinate reference systems and unsupported, rotated
coordinate reference systems. The proj and WKT format strings
have been tested in QGIS 3.0 and 4.0 with success.

UTM stands for Universal Transverse Mercator. It is a common projection
for prospect scale geophysical data. However, its coordinate axis
are aligned with geographic east and north (on the central meridian at
least). To describe an affine rotation between Transverse Mercator
projections, we can use the _Oblique Mercator_ coordinate system
as the destination. We will construct an Oblique Mercator system
with a custom center and rotation of the central meridian from the vertical.
In this way, we can describe an arbitrarily translated grid.

```text
```

where `CENTERX` is the center of the Oblique Mercator alternatively, in WKT format:

```text
```

IN PROGRESS
