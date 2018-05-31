#ifndef GENERICMESH_H
#define GENERICMESH_H

#include <vector>

#include "Eigen"
#include "Output.hpp"

using namespace std;
using namespace Eigen;
using namespace MainApplication;

namespace GeDiM
{
	class GenericDomain;
	class GenericTreeNode;
	class GenericCell;
	class GenericFace;
	class GenericEdge;
	class GenericPoint;
	class GenericMesh;
	class GenericMeshImportInterface;

	class GenericTreeNode
	{
		protected:
			const GenericTreeNode* father; ///< Father node in the tree
			vector<const GenericTreeNode*> childs; ///< Child nodes in the tree.

			unsigned int id; ///< Internal id of the node
			unsigned int globalId; ///< Global id of the node, generally equal to id
			bool isActive; ///< Tells if the node is active for system matrix computation

			unsigned short marker; ///< Marker for Dirichlet and Neumann conditions
		public:
			GenericTreeNode(const unsigned int& _id);
			virtual ~GenericTreeNode();

			const unsigned int& Id() const { return id; }
			const unsigned int& GlobalId() const { return globalId; }
			const bool& IsActive() const { return isActive; }
			const unsigned short& Marker() const { return marker; }
			const bool IsDirichlet() const { return (marker % 2 == 1); }
			const bool IsNeumann() const { return (marker > 0 && marker % 2 == 0); }

			void SetGlobalId(const unsigned int& _globalId) { globalId = _globalId; }
			void SetState(bool _isActive = true) { isActive = _isActive; }
			void SetMarker(const unsigned short& _marker) { marker = _marker; }
	};

	class GenericCell : public GenericTreeNode
	{
		protected:
			vector<const GenericCell*> cells; ///< Cells of the cell
			vector<const GenericFace*> faces; ///< Faces of the cell
			vector<const GenericEdge*> edges; ///< Edges of the cell
			vector<const GenericPoint*> points; ///< Points of the cell

		public:
			GenericCell(const unsigned int& _id);
			virtual ~GenericCell();

			const size_t NumberOfCells() const { return cells.size(); }
			const size_t NumberOfFaces() const { return faces.size(); }
			const size_t NumberOfEdges() const { return edges.size(); }
			const size_t NumberOfPoints() const { return points.size(); }
			const GenericCell* Cell(const unsigned int& position) const { return cells[position]; }
      const GenericFace* Face(const unsigned int& position) const { return faces[position]; }
      const GenericEdge* Edge(const unsigned int& position) const { return edges[position]; }
      const GenericPoint* Point(const unsigned int& position) const { return points[position]; }

			void InitializeCells(const size_t numberOfCells) { cells.reserve(numberOfCells); }
			void InitializeFaces(const size_t numberOfFaces) { faces.reserve(numberOfFaces); }
			void InitializeEdges(const size_t numberOfEdges) { edges.reserve(numberOfEdges); }
			void InitializePoints(const size_t numberOfPoints) { points.reserve(numberOfPoints); }

			void AllocateCells(const size_t numberOfCells) { cells.resize(numberOfCells, NULL); }
			void AllocateFaces(const size_t numberOfFaces) { faces.resize(numberOfFaces, NULL); }
			void AllocateEdges(const size_t numberOfEdges) { edges.resize(numberOfEdges, NULL); }
			void AllocatePoints(const size_t numberOfPoints) { points.resize(numberOfPoints, NULL); }

			Output::ExitCodes AddCell(const GenericCell* cell);
      Output::ExitCodes AddFace(const GenericFace* face);
      Output::ExitCodes AddEdge(const GenericEdge* edge);
      Output::ExitCodes AddPoint(const GenericPoint* point);

      Output::ExitCodes InsertCell(const GenericCell* cell, const unsigned int& position);
			Output::ExitCodes InsertFace(const GenericFace* face, const unsigned int& position);
      Output::ExitCodes InsertEdge(const GenericEdge* edge, const unsigned int& position);
      Output::ExitCodes InsertPoint(const GenericPoint* point, const unsigned int& position);
	};

	class GenericFace : public GenericTreeNode
	{
		protected:
			vector<const GenericCell*> cells; ///< Cells of the face
			vector<const GenericFace*> faces; ///< Faces of the face
			vector<const GenericEdge*> edges; ///< Edges of the face
			vector<const GenericPoint*> points; ///< Points of the face

		public:
			GenericFace(const unsigned int& _id);
			virtual ~GenericFace();

			const size_t NumberOfCells() const { return cells.size(); }
			const size_t NumberOfFaces() const { return faces.size(); }
			const size_t NumberOfEdges() const { return edges.size(); }
			const size_t NumberOfPoints() const { return points.size(); }
			const GenericCell* Cell(const unsigned int& position) const { return cells[position]; }
      const GenericFace* Face(const unsigned int& position) const { return faces[position]; }
      const GenericEdge* Edge(const unsigned int& position) const { return edges[position]; }
      const GenericPoint* Point(const unsigned int& position) const { return points[position]; }

			void InitializeCells(const size_t numberOfCells) { cells.reserve(numberOfCells); }
			void InitializeFaces(const size_t numberOfFaces) { faces.reserve(numberOfFaces); }
			void InitializeEdges(const size_t numberOfEdges) { edges.reserve(numberOfEdges); }
			void InitializePoints(const size_t numberOfPoints) { points.reserve(numberOfPoints); }

			void AllocateCells(const size_t numberOfCells) { cells.resize(numberOfCells, NULL); }
			void AllocateFaces(const size_t numberOfFaces) { faces.resize(numberOfFaces, NULL); }
			void AllocateEdges(const size_t numberOfEdges) { edges.resize(numberOfEdges, NULL); }
			void AllocatePoints(const size_t numberOfPoints) { points.resize(numberOfPoints, NULL); }

			Output::ExitCodes AddCell(const GenericCell* cell);
			Output::ExitCodes AddFace(const GenericFace* face);
      Output::ExitCodes AddEdge(const GenericEdge* edge);
      Output::ExitCodes AddPoint(const GenericPoint* point);

			Output::ExitCodes InsertCell(const GenericCell* cell, const unsigned int& position);
			Output::ExitCodes InsertFace(const GenericFace* face, const unsigned int& position);
      Output::ExitCodes InsertEdge(const GenericEdge* edge, const unsigned int& position);
      Output::ExitCodes InsertPoint(const GenericPoint* point, const unsigned int& position);
	};

	class GenericEdge : public GenericTreeNode
	{
		protected:
			vector<const GenericCell*> cells; ///< Cells of the edge
			vector<const GenericFace*> faces; ///< Faces of the edge
			vector<const GenericEdge*> edges; ///< Edges of the edge
			vector<const GenericPoint*> points; ///< Points of the edge

		public:
			GenericEdge(const unsigned int& _id);
		GenericEdge(const unsigned int& _id, const GenericPoint* origin, const GenericPoint* end);
			virtual ~GenericEdge();

			const size_t NumberOfCells() const { return cells.size(); }
			const size_t NumberOfFaces() const { return faces.size(); }
			const size_t NumberOfEdges() const { return edges.size(); }
			const size_t NumberOfPoints() const { return points.size(); }
			const GenericCell* Cell(const unsigned int& position) const { return cells[position]; }
      const GenericFace* Face(const unsigned int& position) const { return faces[position]; }
      const GenericEdge* Edge(const unsigned int& position) const { return edges[position]; }
      const GenericPoint* Point(const unsigned int& position) const { return points[position]; }

			void InitializeCells(const size_t numberOfCells) { cells.reserve(numberOfCells); }
			void InitializeFaces(const size_t numberOfFaces) { faces.reserve(numberOfFaces); }
			void InitializeEdges(const size_t numberOfEdges) { edges.reserve(numberOfEdges); }

			void AllocateCells(const size_t numberOfCells) { cells.resize(numberOfCells, NULL); }
			void AllocateFaces(const size_t numberOfFaces) { faces.resize(numberOfFaces, NULL); }
			void AllocateEdges(const size_t numberOfEdges) { edges.resize(numberOfEdges, NULL); }
			void AllocatePoints(const size_t numberOfPoints) { points.resize(numberOfPoints, NULL); }

			Output::ExitCodes AddCell(const GenericCell* cell);
      Output::ExitCodes AddFace(const GenericFace* face);
      Output::ExitCodes AddEdge(const GenericEdge* edge);
      Output::ExitCodes AddPoint(const GenericPoint* point);

      Output::ExitCodes InsertCell(const GenericCell* cell, const unsigned int& position);
			Output::ExitCodes InsertFace(const GenericFace* face, const unsigned int& position);
      Output::ExitCodes InsertEdge(const GenericEdge* edge, const unsigned int& position);
      Output::ExitCodes InsertPoint(const GenericPoint* point, const unsigned int& position);
	};

	class GenericPoint : public GenericTreeNode
	{
		protected:
			Vector3d coordinates; ///< Geometry vertex of the degree of freedom. Its size depends on the dimension

			vector<const GenericCell*> cells; ///< Cells of the point
			vector<const GenericFace*> faces; ///< Faces of the point
			vector<const GenericEdge*> edges; ///< Edges of the point

		public:
			GenericPoint(const unsigned int& _id);
			virtual ~GenericPoint();

			const Vector3d& Coordinates() const { return coordinates; }
			const double& X() const { return coordinates[0]; }
			const double& Y() const { return coordinates[1]; }
			const double& Z() const { return coordinates[2]; }
			const size_t NumberOfCells() const { return cells.size(); }
			const size_t NumberOfFaces() const { return faces.size(); }
			const size_t NumberOfEdges() const { return edges.size(); }
			const GenericCell* Cell(const unsigned int& position) const { return cells[position]; }
      const GenericFace* Face(const unsigned int& position) const { return faces[position]; }
      const GenericEdge* Edge(const unsigned int& position) const { return edges[position]; }

			Output::ExitCodes SetCoordinates(const Vector3d& _coordinates);
			Output::ExitCodes SetCoordinates(const double& x, const double& y = 0.0, const double& z = 0.0);

			void InitializeCells(const size_t numberOfCells) { cells.reserve(numberOfCells); }
			void InitializeFaces(const size_t numberOfFaces) { faces.reserve(numberOfFaces); }
			void InitializeEdges(const size_t numberOfEdges) { edges.reserve(numberOfEdges); }

			void AllocateCells(const size_t numberOfCells) { cells.resize(numberOfCells, NULL); }
			void AllocateFaces(const size_t numberOfFaces) { faces.resize(numberOfFaces, NULL); }
			void AllocateEdges(const size_t numberOfEdges) { edges.resize(numberOfEdges, NULL); }

			Output::ExitCodes AddCell(const GenericCell* cell);
      Output::ExitCodes AddFace(const GenericFace* face);
      Output::ExitCodes AddEdge(const GenericEdge* edge);

      Output::ExitCodes InsertCell(const GenericCell* cell, const unsigned int& position);
			Output::ExitCodes InsertFace(const GenericFace* face, const unsigned int& position);
      Output::ExitCodes InsertEdge(const GenericEdge* edge, const unsigned int& position);
	};

	class GenericMesh
	{
		protected:
			vector<GenericCell*> cells; ///< Cells of the mesh
			vector<GenericFace*> faces; ///< Faces of the mesh
			vector<GenericEdge*> edges; ///< Edges of the mesh
			vector<GenericPoint*> points; ///< Points of the mesh

		public:
			GenericMesh();
			virtual ~GenericMesh();

			const size_t NumberOfCells() const { return cells.size(); }
			const size_t NumberOfFaces() const { return faces.size(); }
			const size_t NumberOfEdges() const { return edges.size(); }
			const size_t NumberOfPoints() const { return points.size(); }
      const GenericCell* Cell(const unsigned int& position) const { return cells[position]; }
      const GenericFace* Face(const unsigned int& position) const { return faces[position]; }
      const GenericEdge* Edge(const unsigned int& position) const { return edges[position]; }
      const GenericPoint* Point(const unsigned int& position) const { return points[position]; }
      const unsigned short Dimension() const { if (faces.size() > 0) return 3; else if (edges.size() > 0) return 2; else return 1; }

			virtual GenericCell* CreateCell() { return new GenericCell(cells.size()); }
			virtual GenericFace* CreateFace() { return new GenericFace(faces.size()); }
			virtual GenericEdge* CreateEdge() { return new GenericEdge(edges.size()); }
      virtual GenericPoint* CreatePoint() { return new GenericPoint(points.size()); }

			void InitializeCells(const size_t numberOfCells) { cells.reserve(numberOfCells); }
			void InitializeFaces(const size_t numberOfFaces) { faces.reserve(numberOfFaces); }
			void InitializeEdges(const size_t numberOfEdges) { edges.reserve(numberOfEdges); }
			void InitializePoints(const size_t numberOfPoints) { points.reserve(numberOfPoints); }

      Output::ExitCodes AddCell(GenericCell* cell);
      Output::ExitCodes AddFace(GenericFace* face);
      Output::ExitCodes AddEdge(GenericEdge* edge);
      Output::ExitCodes AddPoint(GenericPoint* point);
	};

	class GenericMeshImportInterface
	{
		protected:
      double minimumCellSize; ///< Size of the minimum cell of the mesh
			unsigned int minimumNumberOfCells; ///< Minimum number of cell of the mesh

			vector<int> vertexMarkers; ///< Vector of boundary conditions of domain vertices
			vector<int> edgeMarkers; ///< Vector of boundary conditions of domain edges
			vector<int> faceMarkers; ///< Vector of boundary conditions of domain faces

		public:
			GenericMeshImportInterface();
			virtual ~GenericMeshImportInterface();

      const double& MinimumCellSize() const { return minimumCellSize; }
      const unsigned int& MinimumNumberOfCells() const { return minimumNumberOfCells; }

      const vector<int>& VertexMarkers() const { return vertexMarkers; }
      const vector<int>& EdgeMarkers() const { return edgeMarkers; }
      const vector<int>& FaceMarkers() const { return faceMarkers; }

      void SetMinimumCellSize(const double& _minimumCellSize) { minimumCellSize = _minimumCellSize; }
      void SetMinimumNumberOfCells(const unsigned int& _minimumNumberOfCells) { minimumNumberOfCells = _minimumNumberOfCells; }
      void SetBoundaryConditions(const vector<int>& _vertexMarkers, const vector<int>& _edgeMarkers = vector<int>(), const vector<int>& _faceMarkers = vector<int>());

			virtual Output::ExitCodes CreateMesh(const GenericDomain& domain, GenericMesh& mesh) const = 0;
	};
}

#endif // GENERICMESH_H
