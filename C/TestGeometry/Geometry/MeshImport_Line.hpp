#ifndef MESHIMPORT_LINE_H
#define MESHIMPORT_LINE_H

#include <vector>

#include "Eigen"

#include "GenericMesh.hpp"
#include "GenericDomain.hpp"

using namespace std;
using namespace Eigen;
using namespace MainApplication;

namespace GeDiM
{
	class MeshImport_Line;

	class MeshImport_Line : public GenericMeshImportInterface
	{
		protected:
			unsigned int minimumNumberOfCells; ///< Minimum number of cell of the mesh

		public:
			MeshImport_Line();
			virtual ~MeshImport_Line();

			const unsigned int& MinimumNumberOfCells() const { return minimumNumberOfCells; }

			void SetMinimumNumberOfCells(const unsigned int& _minimumNumberOfCells) { minimumNumberOfCells = _minimumNumberOfCells; }

			Output::ExitCodes CreateMesh(const GenericDomain& domain, GenericMesh& mesh) const;
	};
}

#endif // MESHIMPORT_LINE_H
