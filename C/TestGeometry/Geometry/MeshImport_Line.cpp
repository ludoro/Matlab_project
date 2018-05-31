#include <math.h>

#include "MeshImport_Line.hpp"
#include "Output.hpp"

using namespace MainApplication;

namespace GeDiM
{
	// ***************************************************************************
	MeshImport_Line::MeshImport_Line() : GenericMeshImportInterface()
	{
		minimumNumberOfCells = 0;
	}
	MeshImport_Line::~MeshImport_Line()
	{
	}
	// ***************************************************************************
	Output::ExitCodes MeshImport_Line::CreateMesh(const GenericDomain& domain, GenericMesh& mesh) const
	{
		/// <ul>

		if (minimumNumberOfCells == 0 && minimumCellSize <= 0)
		{
			Output::PrintErrorMessage("Wrong initialization of the minimumNumberOfCells or minimumCellSize", false);
			return Output::GenericError;
		}

		const GenericDomain1D& domain1D = dynamic_cast<const GenericDomain1D&>(domain);

		const double& domainLength = domain1D.Length();
		double cellLength = minimumNumberOfCells == 0 ? minimumCellSize : domainLength / (double)minimumNumberOfCells;

		unsigned int numberOfCells = ceil(domainLength / cellLength);
		unsigned int numberOfPoints = numberOfCells + 1;

		/// <li>	Fill mesh structures
		mesh.InitializeCells(numberOfCells);
		mesh.InitializePoints(numberOfPoints);

		vector<GenericCell*> cells(numberOfCells, NULL);
		vector<GenericPoint*> points(numberOfPoints, NULL);

		/// <li> Set Points
		for (unsigned int p = 0; p < numberOfPoints; p++)
		{
			points[p] = mesh.CreatePoint();

			GenericPoint* point = points[p];

			point->SetCoordinates(p * cellLength);
			point->InitializeCells(2);

			if (vertexMarkers.size() > 0 && p == 0)
				point->SetMarker(vertexMarkers[0]);

			if (vertexMarkers.size() > 1 && p == (numberOfPoints - 1))
				point->SetMarker(vertexMarkers[1]);

			mesh.AddPoint(point);
		}

		/// <li> Set Cells
    for (unsigned int c = 0; c < numberOfCells; c++)
		{
			cells[c] = mesh.CreateCell();

			GenericCell* cell = cells[c];
			cell->InitializePoints(2);
			cell->InitializeCells(2);

			for (int i = 0; i < 2; i++)
			{
				GenericPoint* point = points[c + i];

				cell->AddPoint(point);
				point->AddCell(cell);
			}

			mesh.AddCell(cell);
		}

		/// <li> Insert Cell Neighbour
		if (numberOfCells > 1)
		{
			for (unsigned int c = 0; c < numberOfCells; c++)
			{
				GenericCell* cell = cells[c];

				if (c == 0)
				{
					cell->AddCell(NULL);
					cell->AddCell(cells[1]);
				}
				else if (c == (numberOfCells - 1))
				{
					cell->AddCell(cells[numberOfCells - 2]);
					cell->AddCell(NULL);
				}
				else
				{
					cell->AddCell(cells[c - 1]);
					cell->AddCell(cells[c + 1]);
				}
			}
		}

		return Output::Success;

		/// </ul>
	}
	// ***************************************************************************
}
