import boundingbox as bb
import math

class QuadTree:
	"""
	The QuadTree class is a tree data structure in which each internal
	non leave node has exactly four children.
	
	the internal data structre `self.quads = {}` is a dictionary where its
	keys represent depth (starting from 0) and has a list of BoundingBoxes representing
	the partions/space. The total area of at each level should remain equal to the initial
	bounding box.
	
	self.quads = 
	{
		0: [1    x BoundingBox ]
		1: [4    x BoundingBox ]
		.. 
		n: [4**n x BoundingBox ]
	}
	
	Generation of the QuadTree is slow, using it to reduce your dataset it fast.

	"""
	def __init__(self,bbox, depth):
		"""
		Create a new QuadTree instance.
		:param bbox: the initial BoundingBox
		:param depth: the depth of the QuadTree

		:Example:
		>>> bbox = bb.BoundingBox(2,9,1,7)
		>>> qt = QuadTree(bbox, 2)
		"""
		self.quads = {}
		self.depth = depth

		for x in range(depth):
			self.quads[x]= []

		self.quads[0] = [bbox]
		self.recurse(bbox, 1)

	def recurse(self,bbox, depth):
		"""
		Internal function called on class contruction, this should 
		create the BoundingBoxes.

		:param bbox: the initial BoundingBox
		:param depth: the depth of the QuadTree

		:To be implemented by the student:		
		"""
		minX = bbox.data[0,0]
		maxX = bbox.data[0,1]
		midX = (minX + maxX) / 2.0
		minY = bbox.data[1,0]
		maxY = bbox.data[1,1]
		midY = (minY + maxY) /2.0
		axis_X = [minX, midX, maxX]
		axis_Y = [minY, midY, maxY]
		# extend dict quads in case of keyerror
		if len(self.quads) <= depth:
			self.quads = [[] for i in range(0, depth+1)]
		for i in range(0,2):
			for j in range(0,2):
				child_bbox = bb.BoundingBox(axis_X[i], axis_X[i+1], axis_Y[j], axis_Y[j+1])
				self.quads[len(self.quads) - depth].append(child_bbox)
				# recurse condition
				if depth > 1:
					self.recurse(child_bbox, depth - 1)
					
		# raise NotImplementedError(":To be implemented by the student:")

	@staticmethod	
	def at_least(size):
		"""
		Returns the amount of BoundingBoxes when the user
		request `at least` an amount of bboxes. The returned
		value is >= than size.
		
		:param size: minimum requested size

		:Example:
		>>> print(QuadTree.at_least(900))
		>>> 1024	
		"""
		return 4**int(math.ceil(math.log(size,4)))

	@staticmethod	
	def at_most(size):
		"""
		Returns the amount of BoundingBoxes when the user
		request `at most` an amount of bboxes. The returned
		value is <= than size.
		
		:param size: maximum requested size

		:Example:
		>>> print(QuadTree.at_most(900))
		>>> 256
		"""
		return 4**int(math.floor(math.log(size,4)))

	@staticmethod	
	def level(size):
		"""
		Returns the level required (rounded up)
		for a given size of elements. 
		return int(math.ceil(math.log(size,4)))
	
		:param size: requested size
		>>> print(QuadTree.level(1))
		>>> 0
		>>> print(QuadTree.level(5))
		>>> 2
		"""
		return int(math.ceil(math.log(size,4)))

	def quadrants(self):
		"""
		Returns the quads member
		"""
		return self.quads

if __name__ == '__main__':

	bbox = bb.BoundingBox(2,9,1,7)
	print(QuadTree.at_least(900))
	print(QuadTree.at_most(900))
	print(QuadTree.level(1))
	print(QuadTree.level(5))
	print(QuadTree.level(900))

	qt = QuadTree(bbox, 2)
	for k,v in qt.quads.items():
		print (k,len(v))
		for x in v:
			print(x.data)
