import quadtree as qt
import boundingbox as bb

bbox = bb.BoundingBox(2,9,1,7)
qtree = qt.QuadTree(bbox, 1)
print(qtree.quads)