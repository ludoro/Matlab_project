#include "Domain2D.hpp"
#include "GenericDomain.hpp"
#include "Output.hpp"

namespace GeDiM
{
	// ***************************************************************************
	// Polygon Implementation
	// ***************************************************************************
	Polygon::Polygon(const unsigned int& _globalId) : GenericDomain2D(_globalId, _totalNumberVertices)
	{
		baseIndex = -1;
		heightIndex = -1;
    totalNumberVertices = _totalNumberVertices;
	}
	Polygon::~Polygon()
	{
	}
	// ***************************************************************************
	Output::ExitCodes Polygon::BuildPolygon(const vector<Vector3d>& vertices);
	{
		/// <ul>

		/// <li> Add vertices and edges

    // !!!!! Nessuna sicurezza sulle prossime 4 linee di codice !!!!!
    AddVertex(vertices[0]);
    for(int i = 1; i < totalNumberVertices; i++){
      AddVertex(vertices[i]);
      AddEdge(i,i-1); //
    }

		Initialize();

		return Output::Success;
    /// <ul>
	}
	// ***************************************************************************
}
