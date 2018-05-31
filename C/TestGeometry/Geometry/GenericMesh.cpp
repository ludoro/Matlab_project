#include "GenericMesh.hpp"
#include "Output.hpp"

using namespace MainApplication;

namespace GeDiM
{
	// ***************************************************************************
	GenericTreeNode::GenericTreeNode(const unsigned int& _id)
	{
		father = NULL;

		id = _id;
		globalId = _id;
		isActive = true;

		marker = 0;
	}
	GenericTreeNode::~GenericTreeNode()
	{
	}
	// ***************************************************************************
	GenericCell::GenericCell(const unsigned int& _id) : GenericTreeNode(_id)
	{
	}
	GenericCell::~GenericCell()
	{
		points.clear();
		edges.clear();
		faces.clear();
		cells.clear();
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::AddCell(const GenericCell* cell)
	{
		if (cell == NULL)
			return Output::GenericError;

		cells.push_back(cell);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::AddFace(const GenericFace* face)
	{
		if (face == NULL)
			return Output::GenericError;

		faces.push_back(face);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::AddEdge(const GenericEdge* edge)
	{
		if (edge == NULL)
			return Output::GenericError;

		edges.push_back(edge);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::AddPoint(const GenericPoint* point)
	{
		if (point == NULL)
			return Output::GenericError;

		points.push_back(point);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::InsertCell(const GenericCell* cell, const unsigned int& position)
	{
		if (cell == NULL || position >= cells.size())
			return Output::GenericError;

		cells[position] = cell;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::InsertFace(const GenericFace* face, const unsigned int& position)
	{
		if (face == NULL || position >= faces.size())
			return Output::GenericError;

		faces[position] = face;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::InsertEdge(const GenericEdge* edge, const unsigned int& position)
	{
		if (edge == NULL || position >= edges.size())
			return Output::GenericError;

		edges[position] = edge;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericCell::InsertPoint(const GenericPoint* point, const unsigned int& position)
	{
		if (point == NULL || position >= points.size())
			return Output::GenericError;

		points[position] = point;

    return Output::Success;
	}
	// ***************************************************************************
	GenericFace::GenericFace(const unsigned int& _id) : GenericTreeNode(_id)
	{
	}
	GenericFace::~GenericFace()
	{
		points.clear();
		edges.clear();
		faces.clear();
		cells.clear();
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::AddCell(const GenericCell* cell)
	{
		if (cell == NULL)
			return Output::GenericError;

		cells.push_back(cell);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::AddFace(const GenericFace* face)
	{
		if (face == NULL)
			return Output::GenericError;

		faces.push_back(face);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::AddEdge(const GenericEdge* edge)
	{
		if (edge == NULL)
			return Output::GenericError;

		edges.push_back(edge);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::AddPoint(const GenericPoint* point)
	{
		if (point == NULL)
			return Output::GenericError;

		points.push_back(point);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::InsertCell(const GenericCell* cell, const unsigned int& position)
	{
		if (cell == NULL || position >= cells.size())
			return Output::GenericError;

		cells[position] = cell;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::InsertFace(const GenericFace* face, const unsigned int& position)
	{
		if (face == NULL || position >= faces.size())
			return Output::GenericError;

		faces[position] = face;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::InsertEdge(const GenericEdge* edge, const unsigned int& position)
	{
		if (edge == NULL || position >= edges.size())
			return Output::GenericError;

		edges[position] = edge;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericFace::InsertPoint(const GenericPoint* point, const unsigned int& position)
	{
		if (point == NULL || position >= points.size())
			return Output::GenericError;

		points[position] = point;

    return Output::Success;
	}
	// ***************************************************************************
	GenericEdge::GenericEdge(const unsigned int& _id) : GenericTreeNode(_id)
	{
		points.reserve(2);
	}
	GenericEdge::GenericEdge(const unsigned int& _id, const GenericPoint* origin, const GenericPoint* end) : GenericEdge(_id)
	{
		AddPoint(origin);
		AddPoint(end);
	}

	GenericEdge::~GenericEdge()
	{
		points.clear();
		edges.clear();
		faces.clear();
		cells.clear();
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::AddCell(const GenericCell* cell)
	{
		if (cell == NULL)
			return Output::GenericError;

		cells.push_back(cell);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::AddFace(const GenericFace* face)
	{
		if (face == NULL)
			return Output::GenericError;

		faces.push_back(face);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::AddEdge(const GenericEdge* edge)
	{
		if (edge == NULL)
			return Output::GenericError;

		edges.push_back(edge);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::AddPoint(const GenericPoint* point)
	{
		if (point == NULL)
			return Output::GenericError;

		points.push_back(point);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::InsertCell(const GenericCell* cell, const unsigned int& position)
	{
		if (cell == NULL || position >= cells.size())
			return Output::GenericError;

		cells[position] = cell;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::InsertFace(const GenericFace* face, const unsigned int& position)
	{
		if (face == NULL || position >= faces.size())
			return Output::GenericError;

		faces[position] = face;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::InsertEdge(const GenericEdge* edge, const unsigned int& position)
	{
		if (edge == NULL || position >= edges.size())
			return Output::GenericError;

		edges[position] = edge;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericEdge::InsertPoint(const GenericPoint* point, const unsigned int& position)
	{
		if (point == NULL || position >= points.size())
			return Output::GenericError;

		points[position] = point;

    return Output::Success;
	}
	// ***************************************************************************
	GenericPoint::GenericPoint(const unsigned int& _id) : GenericTreeNode(_id)
	{
		coordinates.setZero();
	}
	GenericPoint::~GenericPoint()
	{
		edges.clear();
		faces.clear();
		cells.clear();
	}
	// ***************************************************************************
	Output::ExitCodes GenericPoint::SetCoordinates(const Vector3d& _coordinates)
	{
		coordinates = _coordinates;

		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericPoint::SetCoordinates(const double& x, const double& y, const double& z)
	{
		coordinates<< x, y, z;

		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericPoint::AddCell(const GenericCell* cell)
	{
		if (cell == NULL)
			return Output::GenericError;

		cells.push_back(cell);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericPoint::AddFace(const GenericFace* face)
	{
		if (face == NULL)
			return Output::GenericError;

		faces.push_back(face);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericPoint::AddEdge(const GenericEdge* edge)
	{
		if (edge == NULL)
			return Output::GenericError;

		edges.push_back(edge);

    return Output::Success;
	}
		// ***************************************************************************
	Output::ExitCodes GenericPoint::InsertCell(const GenericCell* cell, const unsigned int& position)
	{
		if (cell == NULL || position >= cells.size())
			return Output::GenericError;

		cells[position] = cell;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericPoint::InsertFace(const GenericFace* face, const unsigned int& position)
	{
		if (face == NULL || position >= faces.size())
			return Output::GenericError;

		faces[position] = face;

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericPoint::InsertEdge(const GenericEdge* edge, const unsigned int& position)
	{
		if (edge == NULL || position >= edges.size())
			return Output::GenericError;

		edges[position] = edge;

    return Output::Success;
	}
	// ***************************************************************************
	GenericMesh::GenericMesh()
	{
	}
	GenericMesh::~GenericMesh()
	{
		for (vector<GenericPoint*>::iterator pointPtr = points.begin(); pointPtr != points.end(); pointPtr++)
			delete *pointPtr;

		for (vector<GenericEdge*>::iterator edgePtr = edges.begin(); edgePtr != edges.end(); edgePtr++)
      delete *edgePtr;

		for (vector<GenericFace*>::iterator facePtr = faces.begin(); facePtr != faces.end(); facePtr++)
			delete *facePtr;

		for (vector<GenericCell*>::iterator cellPtr = cells.begin(); cellPtr != cells.end(); cellPtr++)
      delete *cellPtr;

		points.clear();
		edges.clear();
		faces.clear();
		cells.clear();
	}
	// ***************************************************************************
	Output::ExitCodes GenericMesh::AddCell(GenericCell* cell)
	{
		if (cell == NULL)
			return Output::GenericError;

		cells.push_back(cell);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericMesh::AddFace(GenericFace* face)
	{
		if (face == NULL)
			return Output::GenericError;

		faces.push_back(face);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericMesh::AddEdge(GenericEdge* edge)
	{
		if (edge == NULL)
			return Output::GenericError;

		edges.push_back(edge);

    return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericMesh::AddPoint(GenericPoint* point)
	{
		if (point == NULL)
			return Output::GenericError;

		points.push_back(point);

    return Output::Success;
	}
	// ***************************************************************************
	GenericMeshImportInterface::GenericMeshImportInterface()
	{
		minimumCellSize = 0.0;
		minimumNumberOfCells = 0;
	}
	GenericMeshImportInterface::~GenericMeshImportInterface()
	{
	}
	// ***************************************************************************
	void GenericMeshImportInterface::SetBoundaryConditions(const vector<int>& _vertexMarkers, const vector<int>& _edgeMarkers, const vector<int>& _faceMarkers)
	{
		if (_vertexMarkers.size() > 0)
		{
			vertexMarkers.resize(_vertexMarkers.size());
			memcpy(&vertexMarkers[0], &_vertexMarkers[0], _vertexMarkers.size() * sizeof(int));
    }

    if (_edgeMarkers.size() > 0)
		{
			edgeMarkers.resize(_edgeMarkers.size());
			memcpy(&edgeMarkers[0], &_edgeMarkers[0], _edgeMarkers.size() * sizeof(int));
    }

    if (_faceMarkers.size() > 0)
		{
			faceMarkers.resize(_faceMarkers.size());
			memcpy(&faceMarkers[0], &_faceMarkers[0], _faceMarkers.size() * sizeof(int));
    }
	}
	// ***************************************************************************
}
