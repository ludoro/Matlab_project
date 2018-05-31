#ifndef GENERICDOMAIN_H
#define GENERICDOMAIN_H

#include <vector>
#include <string>

#include "Eigen"
#include "Output.hpp"

using namespace std;
using namespace Eigen;
using namespace MainApplication;

namespace GeDiM
{
	class IGenericDomainRotation;
	class GenericDomain;
	class GenericDomain1D;
	class GenericDomain2D;
	class GenericDomain3D;

	class IGenericDomainRotation
	{
		protected:
			Matrix3d rotationMatrix; ///< rotation matrix
			const Vector3d* originTranslation; ///< origin point of the translation
			vector<Vector3d> rotatedVertices; /// Array of vertexes rotated

		public:
			IGenericDomainRotation();
			virtual ~IGenericDomainRotation();

			const size_t NumberRotatedVertices() const { return rotatedVertices.size(); }
			const Vector3d& RotatedVertex(const unsigned int& i) const { return rotatedVertices[i]; }
			const Matrix3d& RotationMatrix() const { return rotationMatrix; }

			void SetRotationMatrix(const Matrix3d& _rotationMatrix) { rotationMatrix = _rotationMatrix; }
			void SetOriginTranslation(const Vector3d& _originTranslation) { originTranslation = &_originTranslation; }

			virtual Output::ExitCodes ComputeRotationMatrix(const double& rotationTolerance = 1.0e-12) = 0;

			Output::ExitCodes RotateVertices(const vector<Vector3d>& verticesToRotate, const double& rotationTolerance = 1e-05);
			Vector3d RotatePoint(const Vector3d& point, const bool& inverse = false) const { if (originTranslation == NULL) { if (inverse) return rotationMatrix * point; else return rotationMatrix.transpose() * point; } else { if (inverse) return rotationMatrix * point + *originTranslation; else return rotationMatrix.transpose() * (point - *originTranslation); } }
	};

	class GenericDomain
	{
		protected:
			unsigned int globalId; ///< Id of the domain
			string description; ///< Description of the domain

			unsigned int totalNumberVertices; ///< Number of vertices of the domain
			unsigned int totalNumberEdges; ///< Number of edges of the domain
			unsigned int totalNumberFaces; ///< Number of faces of the domain

			vector<Vector3d> vertices; ///< Array of domain vertices
			vector<unsigned int> edgeVertices; ///< Vertex indices for each edge of the domain

			vector< vector<unsigned int> > faceVertices; ///< Vertex indices for each face of the domain
			vector< vector<unsigned int> > faceEdges; ///< Edge indices for each face of the domain

			double measure; ///< Measure of the domain

			Vector3d centroid; ///< Centroid of the domain

		public:
			GenericDomain(const unsigned int& _globalId, const unsigned int& _totalNumberVertices);
			virtual ~GenericDomain();

			const unsigned int& GlobalId() const { return globalId; }
			const string& Description() const { return description; }

			const unsigned int& TotalNumberVertices() const { return totalNumberVertices; }
			const size_t NumberVertices() const { return vertices.size(); }
			const Vector3d& Vertex(const unsigned int& i) const { return vertices[i]; }

			const unsigned int& TotalNumberEdges() const { return totalNumberEdges; }
			const size_t NumberEdges() const { return edgeVertices.size() / 2; }
			const unsigned int& EdgeOriginIndex(const unsigned int& edgeNumber) const { return edgeVertices[2 * edgeNumber]; }
			const unsigned int& EdgeEndIndex(const unsigned int& edgeNumber) const { return edgeVertices[2 * edgeNumber + 1]; }

			const unsigned int& TotalNumberFaces() const { return totalNumberFaces; }
			const size_t NumberFaces() const { return faceVertices.size(); }
			const size_t NumberFacePoints(const unsigned int& faceNumber) const { return faceVertices[faceNumber].size(); }
			const size_t NumberFaceEdges(const unsigned int& faceNumber) const { return faceEdges[faceNumber].size(); }
			const unsigned int FacePointIndex(const unsigned int& faceNumber, const unsigned int& pointNumber) const { return faceVertices[faceNumber][pointNumber]; }
			const unsigned int FaceEdgeIndex(const unsigned int& faceNumber, const unsigned int& edgeNumber) const { return faceEdges[faceNumber][edgeNumber]; }

			const double& Measure() const { return measure; }
			const Vector3d& Centroid() const { return centroid; }
			virtual const unsigned int Dimension() const = 0;

			void SetDescription(const string& _description) { description = _description; }
			virtual Output::ExitCodes Initialize() = 0;

			Output::ExitCodes AddVertex(const Vector3d& vertex);

			void InitializeEdges(const unsigned int& _totalNumberEdges) { totalNumberEdges = _totalNumberEdges; edgeVertices.reserve(2 * totalNumberEdges); }
			Output::ExitCodes AddEdge(const unsigned int& originNumber, const unsigned int& endNumber);

			void InitializeFaces(const unsigned int& _totalNumberFaces) { totalNumberFaces = _totalNumberFaces; faceVertices.reserve(totalNumberFaces); faceEdges.reserve(totalNumberFaces); }
			Output::ExitCodes AddFace(vector<unsigned int> _faceVertices, vector<unsigned int> _faceEdges);
	};

	class GenericDomain1D : public GenericDomain, public IGenericDomainRotation
	{
		protected:
			Vector3d tangent; ///< Tangent of the domain in the space: it's norm is one

		public:
			GenericDomain1D(const unsigned int& _globalId);
			virtual ~GenericDomain1D();

			const double& Length() const { return measure; }
			virtual const unsigned int Dimension() const { return 1; }

			virtual Output::ExitCodes Initialize();
			virtual Output::ExitCodes ComputeRotationMatrix(const double& rotationTolerance = 1.0e-12);

			Output::ExitCodes ComputeTangent();
			Output::ExitCodes ComputeLengthAndCentroid(const double& lengthTolerance = 1e-16);
	};

	class GenericDomain2D : public GenericDomain, public IGenericDomainRotation
	{
		protected:
			Vector3d planeNormal; ///< Normal of plane containing the domain in the space: comes from the equation ax+by+cz = d
			double planeTranslation; ///< plane translation in the space: comes from the equation ax+by+cz = d

		public:
			GenericDomain2D(const unsigned int& _globalId, const unsigned int& _totalNumberVertices);
			virtual ~GenericDomain2D();

			const double& Area() const { return measure; }
			virtual const unsigned int Dimension() const { return 2; }

			virtual Output::ExitCodes Initialize();
			virtual Output::ExitCodes ComputeRotationMatrix(const double& rotationTolerance = 1.0e-12);

			Output::ExitCodes ComputePlane();
			Output::ExitCodes ComputeAreaAndCentroid(const double& areaTolerance = 1.0e-16);
	};

	class GenericDomain3D : public GenericDomain
	{
		protected:

		public:
			GenericDomain3D(const unsigned int& _globalId, const unsigned int& _totalNumberVertices, const unsigned int& _totalNumberEdges, const unsigned int& _totalNumberFaces);
			virtual ~GenericDomain3D();

			const double& Volume() const { return measure; }
			virtual const unsigned int Dimension() const { return 3; }

			virtual Output::ExitCodes Initialize() { return Output::Success; }
	};
}

#endif // GENERICDOMAIN_H
