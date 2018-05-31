#include "Domain3D.hpp"
#include "GenericDomain.hpp"
#include "Output.hpp"

namespace GeDiM
{
	// ***************************************************************************
	// Parallelepiped Implementation
	// ***************************************************************************
	Parallelepiped::Parallelepiped(const unsigned int& _globalId) : GenericDomain3D(_globalId, 8, 12, 6)
	{
		baseIndex = -1;
		heightIndex = -1;
	}
	Parallelepiped::~Parallelepiped()
	{
	}
	// ***************************************************************************
	Output::ExitCodes Parallelepiped::BuildParallelepiped(const Vector3d& origin, const Vector3d& lengthVector, const Vector3d& heightVector, const Vector3d& widthVector, const double& volumeTolerance)
	{
		/// <ul>

		/// <li> Add first vertex where the base starts
    AddVertex(origin);

    /// <li> Add base
		AddVertex(origin + lengthVector);
		AddVertex(origin + lengthVector + widthVector);
		AddVertex(origin + widthVector);

		AddEdge(0, 1);
		AddEdge(1, 2);
		AddEdge(3, 4);
		AddEdge(4, 0);

		AddFace(vector<unsigned int> { 0, 1, 2, 3 }, vector<unsigned int> { 0, 1, 2, 3 });

		baseIndex = 0;

		/// <li> Add heigth
		AddVertex(origin + heightVector);

		AddEdge(0, 4);
		AddEdge(1, 5);
		AddEdge(2, 6);
		AddEdge(3, 7);

		AddFace(vector<unsigned int> { 0, 1, 5, 4 }, vector<unsigned int> { 0, 5, 8, 4 });
		AddFace(vector<unsigned int> { 1, 3, 7, 6 }, vector<unsigned int> { 1, 6, 9, 5 });
		AddFace(vector<unsigned int> { 3, 4, 8, 7 }, vector<unsigned int> { 2, 7, 10, 6 });
		AddFace(vector<unsigned int> { 0, 5, 8, 4 }, vector<unsigned int> { 3, 7, 11, 4 });

		heightIndex = 4;

		/// <li> Add last points
		AddVertex(origin + heightVector + lengthVector);
		AddVertex(origin + heightVector + widthVector);
		AddVertex(origin + heightVector + lengthVector + widthVector);

		AddEdge(4, 5);
		AddEdge(5, 6);
		AddEdge(6, 7);
		AddEdge(7, 4);

		AddFace(vector<unsigned int> { 4, 5, 6, 7 }, vector<unsigned int> { 8, 9, 10, 11 });

		/// <li> Compute Volume and Centroid
		measure = abs(heightVector.dot(lengthVector.cross(widthVector)));
    centroid = origin + lengthVector * 0.5 + heightVector * 0.5 + widthVector * 0.5;

    if (fabs(measure) < volumeTolerance)
		{
			Output::PrintErrorMessage("Parallelepiped %d has area too small: %.2e - tolerance %.2e", false, globalId, measure, volumeTolerance);
			return Output::GenericError;
		}

		return Output::Success;
    /// <ul>
	}
	// ***************************************************************************
}
