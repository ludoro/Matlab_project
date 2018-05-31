#ifndef UNITTEST_H
#define UNITTEST_H

using namespace std;

namespace GeDiM
{
	class UnitTest;
	class GenericDomain_UnitTest;
	class GenericMesh_UnitTest;

	class UnitTest
	{
    public:
      static void RunAllTests();
	};

	class GenericDomain_UnitTest
	{
		public:
			// GenericDomain1D Tests
			static void GenericDomain1D_Creation();
			static void GenericDomain1D_Vertices();
			static void GenericDomain1D_Initialize();

			 // GenericDomain2D Tests
			static void GenericDomain2D_Creation();
			static void GenericDomain2D_Vertices();

			 // GenericDomain3D Tests
			static void GenericDomain3D_Creation();
	};

	class Domain2D_UnitTest
	{
    public:
			// Parallelepiped Tests
			static void Parallelogram_Creation();
	};

	class Domain3D_UnitTest
	{
    public:
			// Parallelepiped Tests
			static void Parallelepiped_Creation();
	};

	class GenericMesh_UnitTest
	{
		public:
			// GenericTreeNode Tests
			static void GenericTreeNode_Creation();
			// GeneriPoint Tests
			static void GenericPoint_Creation();
			// GenericMesh Tests
			static void GenericMesh_Creation();
	};

	class GenericMeshImportInterface_UnitTest
	{
		public:
			// MeshImport_Line Tests
			static void MeshImport_Line_MinimumNumberCell_Creation();
			static void MeshImport_Line_MinimumCellSize_Creation();
	};

}

#endif // UNITTEST_H
