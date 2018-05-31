#include "Domain2D.hpp"
#include "GenericDomain.hpp"
#include "Output.hpp"

namespace GeDiM
{
	// ***************************************************************************
	// Parallelogram Implementation
	// ***************************************************************************
	Parallelogram::Parallelogram(const unsigned int& _globalId) : GenericDomain2D(_globalId, 4)
	{
		baseIndex = -1;
		heightIndex = -1;
	}
	Parallelogram::~Parallelogram()
	{
	}
	// ***************************************************************************
	Output::ExitCodes Parallelogram::BuildParallelogram(const Vector3d& origin, const Vector3d& lengthVector, const Vector3d& widthVector)
	{
		/// <ul>

		/// <li> Add vertices
    AddVertex(origin);
		AddVertex(origin + lengthVector);
		AddVertex(origin + lengthVector + widthVector);
		AddVertex(origin + widthVector);

		AddEdge(0, 1);
		AddEdge(1, 2);
		AddEdge(2, 3);
		AddEdge(3, 0);

		baseIndex = 0;
		heightIndex = 3;

		Initialize();

		return Output::Success;
    /// <ul>
	}
	// ***************************************************************************
}
