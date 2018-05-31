#include "UnitTest.hpp"
#include "Output.hpp"

#include "Eigen"

#include "GenericDomain.hpp"
#include "GenericMesh.hpp"
#include "Domain2D.hpp"
#include "Domain3D.hpp"
#include "MeshImport_Line.hpp"


using namespace std;
using namespace MainApplication;
using namespace Eigen;

namespace GeDiM
{
	// ***************************************************************************
	void UnitTest::RunAllTests()
	{
    Output::PrintGenericMessage("Starting all tests", true);

    Output::PrintLine('-');
    Output::PrintGenericMessage("GenericDomain1D tests", true);
    Output::PrintLine('-');
    GenericDomain_UnitTest::GenericDomain1D_Creation();
		GenericDomain_UnitTest::GenericDomain1D_Vertices();
		GenericDomain_UnitTest::GenericDomain1D_Initialize();

		Output::PrintLine('-');
		Output::PrintGenericMessage("GenericDomain2D tests", true);
		Output::PrintLine('-');
    GenericDomain_UnitTest::GenericDomain2D_Creation();
    GenericDomain_UnitTest::GenericDomain2D_Vertices();

    Output::PrintLine('-');
		Output::PrintGenericMessage("Domain2D tests", true);
		Output::PrintLine('-');
    Domain2D_UnitTest::Parallelogram_Creation();

    Output::PrintLine('-');
		Output::PrintGenericMessage("GenericDomain3D tests", true);
		Output::PrintLine('-');
    GenericDomain_UnitTest::GenericDomain3D_Creation();

		Output::PrintLine('-');
		Output::PrintGenericMessage("Domain3D tests", true);
		Output::PrintLine('-');
    Domain3D_UnitTest::Parallelepiped_Creation();

    Output::PrintLine('-');
    Output::PrintGenericMessage("GenericTreeNode tests", true);
		Output::PrintLine('-');
		GenericMesh_UnitTest::GenericTreeNode_Creation();

		Output::PrintLine('-');
    Output::PrintGenericMessage("GenericPoint tests", true);
		Output::PrintLine('-');
		GenericMesh_UnitTest::GenericPoint_Creation();

		Output::PrintLine('-');
    Output::PrintGenericMessage("GenericMesh tests", true);
		Output::PrintLine('-');
		GenericMesh_UnitTest::GenericMesh_Creation();

		Output::PrintLine('-');
    Output::PrintGenericMessage("GenericMeshImportInterface tests", true);
		Output::PrintLine('-');
		GenericMeshImportInterface_UnitTest::MeshImport_Line_MinimumNumberCell_Creation();
		GenericMeshImportInterface_UnitTest::MeshImport_Line_MinimumCellSize_Creation();
	}
	// ***************************************************************************
	// GenericDomain1D Implementation
	// ***************************************************************************
	void GenericDomain_UnitTest::GenericDomain1D_Creation()
	{
		unsigned int id = 1;

		GenericDomain1D domain(id);
		domain.SetDescription("Line");

		Output::Assert(domain.GlobalId() == 1, "%s: Test Id", __func__);
		Output::Assert(domain.Description() == "Line", "%s: Test Description", __func__);
	}
	// ***************************************************************************
	void GenericDomain_UnitTest::GenericDomain1D_Vertices()
	{
		unsigned int id = 1, numberVertices = 2;

		GenericDomain1D domain(id);

		Output::Assert(domain.AddVertex(Vector3d(0.0, 0.0, 0.0)), "%s: Test AddVertex", __func__);

		domain.AddVertex(Vector3d(0.0, 1.0, 0.0));

		Output::Assert(domain.TotalNumberVertices() == numberVertices, "%s: Test TotalNumberVertices", __func__);
		Output::Assert(domain.NumberVertices() == numberVertices, "%s: Test NumberVertices", __func__);
	}
	// ***************************************************************************
	void GenericDomain_UnitTest::GenericDomain1D_Initialize()
	{
		unsigned int id = 1;

		GenericDomain1D domain(id);

		double angle = 0.785398; // 45°
		Matrix3d rotationMatrix;
		rotationMatrix.row(0) << cos(angle), 0.0, sin(angle);
		rotationMatrix.row(1) << 0.0, 1.0, 0.0;
		rotationMatrix.row(2) << -sin(angle), 0.0, cos(angle);
		Vector3d vertexOne(0.0, 0.0, 0.0), vertexTwo(1.0, 0.0, 0.0);

		domain.AddVertex(rotationMatrix * vertexOne);
		domain.AddVertex(rotationMatrix * vertexTwo);

		Output::Assert(domain.Initialize(), "%s: Test Initialize", __func__);
		Output::Assert(abs(domain.Length() - 1.0) < 1e-12, "%s: Test Length", __func__);

		Vector3d centroid = rotationMatrix.transpose() * domain.Centroid();

		Output::Assert(abs(centroid[0] - 0.5) < 1e-12, "%s: Test Centroid 1", __func__);
		Output::Assert(abs(centroid[1] - 0.0) < 1e-12, "%s: Test Centroid 2", __func__);
		Output::Assert(abs(centroid[2] - 0.0) < 1e-12, "%s: Test Centroid 3", __func__);
	}
	// ***************************************************************************
	// GenericDomain2D Implementation
	// ***************************************************************************
	void GenericDomain_UnitTest::GenericDomain2D_Creation()
	{
		unsigned int id = 1;

		GenericDomain2D domain(id, 4);
		domain.SetDescription("Square");

		Output::Assert(domain.GlobalId() == 1, "%s: Test Id", __func__);
		Output::Assert(domain.Description() == "Square", "%s: Test Description", __func__);
	}
	// ***************************************************************************
	void GenericDomain_UnitTest::GenericDomain2D_Vertices()
	{
		unsigned int id = 1, numberVertices = 4;

		GenericDomain2D domain(id, numberVertices);

		Output::Assert(domain.AddVertex(Vector3d(0.0,0.0,0.0)), "%s: Test AddVertex", __func__);

		domain.AddVertex(Vector3d(0.0,1.0,0.0));
		domain.AddVertex(Vector3d(1.0,1.0,0.0));
		domain.AddVertex(Vector3d(1.0,0.0,0.0));

		Output::Assert(domain.TotalNumberVertices() == numberVertices, "%s: Test TotalNumberVertices", __func__);
		Output::Assert(domain.NumberVertices() == numberVertices, "%s: Test NumberVertices", __func__);
	}
	// ***************************************************************************
	// Domain2D Implementation
	// ***************************************************************************
	void Domain2D_UnitTest::Parallelogram_Creation()
	{
		unsigned int id = 1;

		Parallelogram domain(id);

		double angle = 0.785398; // 45°
		Matrix3d rotationMatrix;
		rotationMatrix.row(0) << cos(angle), 0.0, sin(angle);
		rotationMatrix.row(1) << 0.0, 1.0, 0.0;
		rotationMatrix.row(2) << -sin(angle), 0.0, cos(angle);

		Vector3d origin(1.0, 1.0, 1.0), length(1.0, 0.0, 0.0), width(0.0, 1.0, 0.0);

    Output::Assert(domain.BuildParallelogram(rotationMatrix * origin, rotationMatrix * length, rotationMatrix * width), "%s: Test BuildParallelogram", __func__);

		Output::Assert(abs(domain.Area() - 1.0) < 1e-12, "%s: Test Area", __func__);

		Vector3d centroid = rotationMatrix.transpose() * domain.Centroid();

		Output::Assert(abs(centroid[0] - 1.5) < 1e-12, "%s: Test Centroid 1", __func__);
		Output::Assert(abs(centroid[1] - 1.5) < 1e-12, "%s: Test Centroid 2", __func__);
		Output::Assert(abs(centroid[2] - 1.0) < 1e-12, "%s: Test Centroid 3", __func__);
	}
	// ***************************************************************************
	// GenericDomain3D Implementation
	// ***************************************************************************
	void GenericDomain_UnitTest::GenericDomain3D_Creation()
	{
		unsigned int id = 1, numberVertices = 8, numberEdges = 12, numberFaces = 6;

		GenericDomain3D domain(id, numberVertices, numberEdges, numberFaces);
		domain.SetDescription("Cube");

		Output::Assert(domain.GlobalId() == 1, "%s: Test Id", __func__);
		Output::Assert(domain.Description() == "Cube", "%s: Test Description", __func__);
	}
	// ***************************************************************************
	// Domain3D Implementation
	// ***************************************************************************
	void Domain3D_UnitTest::Parallelepiped_Creation()
	{
		unsigned int id = 1;

		Parallelepiped domain(id);
		Vector3d origin(1.0, 1.0, 1.0), length(1.0, 0.0, 0.0), height(0.0, 0.0, 1.0), width(0.0, 1.0, 0.0);

    domain.BuildParallelepiped(origin, length, height, width);

    Output::Assert(abs(domain.Volume() - 1.0) < 1e-12, "%s: Test Volume", __func__);

    Output::Assert(abs(domain.Centroid()[0] - 1.5) < 1e-12, "%s: Test Centroid 1", __func__);
		Output::Assert(abs(domain.Centroid()[1] - 1.5) < 1e-12, "%s: Test Centroid 2", __func__);
		Output::Assert(abs(domain.Centroid()[2] - 1.5) < 1e-12, "%s: Test Centroid 3", __func__);
	}
	// ***************************************************************************
	// GenericTreeNode Implementation
	// ***************************************************************************
	void GenericMesh_UnitTest::GenericTreeNode_Creation()
	{
		unsigned int id = 1, globalId = 2;

		GenericTreeNode treeNode(id);
		treeNode.SetGlobalId(globalId);
		treeNode.SetState(false);
		treeNode.SetMarker(1);

		Output::Assert(treeNode.Id() == id, "%s: Test Id", __func__);
		Output::Assert(treeNode.GlobalId() == globalId, "%s: Test GlobalId", __func__);
		Output::Assert(treeNode.IsActive() == false, "%s: Test State", __func__);
		Output::Assert(treeNode.IsDirichlet() == true, "%s: Test Marker", __func__);
	}
	// ***************************************************************************
	// GenericPoint Implementation
	// ***************************************************************************
	void GenericMesh_UnitTest::GenericPoint_Creation()
	{
		unsigned int id = 1;

		GenericPoint point(id);

		Output::Assert(point.SetCoordinates(1.0, 2.0, 3.0), "%s: Test SetCoordinates", __func__);
		Output::Assert(point.Coordinates()[0] == 1.0, "%s: Test Coordinates x", __func__);
		Output::Assert(point.Coordinates()[1] == 2.0, "%s: Test Coordinates y", __func__);
		Output::Assert(point.Coordinates()[2] == 3.0, "%s: Test Coordinates z", __func__);
	}
	// ***************************************************************************
	// GenericMesh Implementation
	// ***************************************************************************
	void GenericMesh_UnitTest::GenericMesh_Creation()
	{
		GenericMesh mesh;

    size_t numberOfCells = 1, numberOfFaces = 1, numberOfEdges = 1, numberOfPoints = 1;

		mesh.InitializeCells(numberOfCells);
		mesh.InitializeFaces(numberOfFaces);
		mesh.InitializeEdges(numberOfEdges);
		mesh.InitializePoints(numberOfPoints);

		GenericCell* newCell = mesh.CreateCell();
		GenericFace* newFace = mesh.CreateFace();
		GenericEdge* newEdge = mesh.CreateEdge();
		GenericPoint* newPoint = mesh.CreatePoint();

		Output::Assert(mesh.AddCell(newCell), "%s: Test AddCell", __func__);
		Output::Assert(mesh.AddFace(newFace), "%s: Test AddFace", __func__);
		Output::Assert(mesh.AddEdge(newEdge), "%s: Test AddEdge", __func__);
		Output::Assert(mesh.AddPoint(newPoint), "%s: Test AddPoint", __func__);

		Output::Assert(mesh.NumberOfCells() == numberOfCells, "%s: Test NumberOfCells", __func__);
		Output::Assert(mesh.NumberOfFaces() == numberOfFaces, "%s: Test NumberOfFaces", __func__);
		Output::Assert(mesh.NumberOfEdges() == numberOfEdges, "%s: Test NumberOfEdges", __func__);
		Output::Assert(mesh.NumberOfPoints() == numberOfPoints, "%s: Test NumberOfPoints", __func__);
	}
	// ***************************************************************************
	// GenericMeshImportInterface Implementation
	// ***************************************************************************
	void GenericMeshImportInterface_UnitTest::MeshImport_Line_MinimumNumberCell_Creation()
	{
		vector<int> vertexMarkers(2, 1);
		unsigned int minimumNumberCell = 10;

		MeshImport_Line meshImportLine;
		meshImportLine.SetMinimumNumberOfCells(minimumNumberCell);
		meshImportLine.SetBoundaryConditions(vertexMarkers);

		GenericDomain1D domain(1);
		domain.AddVertex(Vector3d(0.0, 0.0, 0.0));
		domain.AddVertex(Vector3d(0.0, 1.0, 0.0));
		domain.Initialize();

		GenericMesh mesh;

    Output::Assert(meshImportLine.CreateMesh(domain, mesh), "%s: Test mesh creation", __func__);
		Output::Assert(mesh.NumberOfCells() == 10, "%s: Test mesh NumberOfCells", __func__);
		Output::Assert(mesh.NumberOfPoints() == 11, "%s: Test mesh NumberOfCells", __func__);
		Output::Assert(mesh.Point(0)->Marker() == 1 && mesh.Point(10)->Marker() == 1, "%s: Test point markers", __func__);
	}
	// ***************************************************************************
	void GenericMeshImportInterface_UnitTest::MeshImport_Line_MinimumCellSize_Creation()
	{
		vector<int> vertexMarkers(2, 1);
		double minimumCellSize = 0.1;

		MeshImport_Line meshImportLine;
		meshImportLine.SetMinimumCellSize(minimumCellSize);
		meshImportLine.SetBoundaryConditions(vertexMarkers);

		GenericDomain1D domain(1);
		domain.AddVertex(Vector3d(0.0, 0.0, 0.0));
		domain.AddVertex(Vector3d(0.0, 1.0, 0.0));
		domain.Initialize();

		GenericMesh mesh;

    Output::Assert(meshImportLine.CreateMesh(domain, mesh), "%s: Test mesh creation", __func__);
		Output::Assert(mesh.NumberOfCells() == 10, "%s: Test mesh NumberOfCells", __func__);
		Output::Assert(mesh.NumberOfPoints() == 11, "%s: Test mesh NumberOfCells", __func__);
		Output::Assert(mesh.Point(0)->Marker() == 1 && mesh.Point(10)->Marker() == 1, "%s: Test point markers", __func__);
	}
	// ***************************************************************************
}

