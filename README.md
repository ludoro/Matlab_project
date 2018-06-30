# Matlab_project

The project is divided in three parts: 2D, 3D and C++. 

## 2D

Given a segment and a triangulated polygon, we need to understand if the segment "cuts" the polygon, if that is the case, we need to triangualte the cut figures. Images are worth many words: 

![img](https://i.imgur.com/ffmdsdf.png)
![img](https://i.imgur.com/VCEAfhs.png)

In red we can see the segment, in blue the triangles that are cut, in gray the triangles that are near triangles that are cut. 
The red dot are the intersections between the segment and a triangle. The light blue lines are the triangulations of the triangels that are cut.

## 3D 

Given a polygon in the space and a parallelepiped, we need to understand if the polygon "cuts" the parallelepiped. If that is the case, we need to divide the cut sections in subsections. As before, images:

![img](https://i.imgur.com/ojKxKJX.png)
![img](https://i.imgur.com/nHrkpJS.png)
![img](https://i.imgur.com/OhPgX3n.png)
![img](https://i.imgur.com/PBwTBCS.png)

In red we have the polygon. In blue we have the cut tetrahedrons, in pink we have the tetrahedron that are near cut tetrahedrons. In yellow we have the polygons formed by the cut. 

## C++

Just a translation of the 2D project in C++, with the same functionality. 
