#include "GenericDomain.hpp"
#include "Output.hpp"

namespace GeDiM
{
	// ***************************************************************************
	// IGenericDomainRotation Implementation
	// ***************************************************************************
	IGenericDomainRotation::IGenericDomainRotation()
	{
		rotationMatrix.setIdentity();
	}
	IGenericDomainRotation::~IGenericDomainRotation()
	{
		rotatedVertices.clear();
	}
	// ***************************************************************************
	Output::ExitCodes IGenericDomainRotation::RotateVertices(const vector<Vector3d>& verticesToRotate, const double& rotationTolerance)
	{
		const unsigned int& numVertices = verticesToRotate.size();

		rotatedVertices.reserve(numVertices);

		for(unsigned int i = 0; i < numVertices; i++)
			rotatedVertices.push_back(RotatePoint(verticesToRotate[i]));

		return Output::Success;
	}
	// ***************************************************************************
	// GenericDomain Implementation
	// ***************************************************************************
	GenericDomain::GenericDomain(const unsigned int& _globalId, const unsigned int& _totalNumberVertices)
	{
		if (_totalNumberVertices == 0)
		{
			Output::PrintWarningMessage("Impossible to create domain %d with zero vertices", false, _globalId);
			return;
		}

		globalId = _globalId;
		totalNumberVertices = _totalNumberVertices;

		totalNumberEdges = 0;
		totalNumberFaces = 0;

		vertices.reserve(totalNumberVertices);
		measure = 0.0;

		centroid.setZero();
		description = "Domain";
	}
	GenericDomain::~GenericDomain()
	{
		vertices.clear();
		edgeVertices.clear();

		for (unsigned int f = 0; f < faceEdges.size(); f++)
			faceEdges[f].clear();
		faceEdges.clear();

		for (unsigned int f = 0; f < faceVertices.size(); f++)
			faceVertices[f].clear();
		faceVertices.clear();
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain::AddVertex(const Vector3d& vertex)
	{
		if (vertices.size() == totalNumberVertices)
			return Output::GenericError;

		vertices.push_back(vertex);
		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain::AddEdge(const unsigned int& originNumber, const unsigned int& endNumber)
	{
		if (edgeVertices.size() == 2 * totalNumberEdges || originNumber > totalNumberVertices - 1 || endNumber > totalNumberVertices - 1)
			return Output::GenericError;

		edgeVertices.push_back(originNumber);
		edgeVertices.push_back(endNumber);

		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain::AddFace(vector<unsigned int> _faceVertices, vector<unsigned int> _faceEdges)
	{
		if (faceVertices.size() == totalNumberFaces || _faceVertices.size() == 0 || _faceEdges.size() == 0)
			return Output::GenericError;

		faceVertices.push_back(vector<unsigned int>(_faceVertices.size()));
		faceEdges.push_back(vector<unsigned int>(_faceEdges.size()));

		memcpy(faceVertices.back().data(), _faceVertices.data(), _faceVertices.size() * sizeof(unsigned int));
		memcpy(faceEdges.back().data(), _faceEdges.data(), _faceEdges.size() * sizeof(unsigned int));

		return Output::Success;
	}
	// ***************************************************************************
	// GenericDomain1D Implementation
	// ***************************************************************************
	GenericDomain1D::GenericDomain1D(const unsigned int& _globalId) : GenericDomain(_globalId, 2)
	{
		tangent.setZero();
	}
	GenericDomain1D::~GenericDomain1D()
	{
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain1D::Initialize()
	{
		Output::ExitCodes result;

		result = ComputeTangent();
		if (result != Output::Success)
			return result;

		SetOriginTranslation(vertices[0]);
		result = ComputeRotationMatrix();
		if (result != Output::Success)
			return result;

		result = RotateVertices(vertices);
		if (result != Output::Success)
			return result;

		result = ComputeLengthAndCentroid();
		if (result != Output::Success)
			return result;

		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain1D::ComputeTangent()
	{
		/// <ul>
		if (NumberVertices() != TotalNumberVertices())
		{
			Output::PrintWarningMessage("Impossible to compute the geometric properties of domain %d. It has %d vertices, expected %d.", false, globalId, NumberVertices(), TotalNumberVertices());
			return Output::GenericError;
		}

		/// <li> Compute tangent
    tangent = vertices[1] - vertices[0];
    tangent.normalize();

		return Output::Success;

		/// </ul>
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain1D::ComputeRotationMatrix(const double& rotationTolerance)
	{
		if (NumberVertices() != TotalNumberVertices())
		{
			Output::PrintWarningMessage("Impossible to compute the geometric properties of domain %d. It has %d vertices, expected %d.", false, globalId, NumberVertices(), TotalNumberVertices());
			return Output::GenericError;
		}

    if (fabs(tangent[0] * tangent[0] - 1.0) < rotationTolerance)
			rotationMatrix.setIdentity();
		else
		{
			rotationMatrix.row(0) << 1 - (tangent[1] * tangent[1] + tangent[2] * tangent[2]) / (1 + tangent[0]), tangent[1], tangent[2];
			rotationMatrix.row(1) << - tangent[1], 1 - (tangent[1] * tangent[1]) / (1 + tangent[0]), - tangent[1] * tangent[2] / (1 + tangent[0]);
			rotationMatrix.row(2) << - tangent[2], - tangent[1] * tangent[2] / (1 + tangent[0]), 1 - (tangent[2] * tangent[2]) / (1 + tangent[0]);

			rotationMatrix.transposeInPlace();
		}

		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain1D::ComputeLengthAndCentroid(const double& lengthTolerance)
	{
		if (NumberVertices() != TotalNumberVertices())
		{
			Output::PrintWarningMessage("Impossible to compute the geometric properties of domain %d. It has %d vertices, expected %d.", false, globalId, NumberVertices(), TotalNumberVertices());
			return Output::GenericError;
		}

		measure = (vertices[0] - vertices[1]).norm();
		centroid = (vertices[0] + vertices[1]) / 2.0;

		if (fabs(measure) < lengthTolerance)
		{
			measure = 0.0;
			Output::PrintErrorMessage("Domain %d has length too small: %.2e - tolerance %.2e", false, globalId, measure, lengthTolerance);
			return Output::GenericError;
		}

		return Output::Success;
	}
	// ***************************************************************************
	// GenericDomain2D Implementation
	// ***************************************************************************
	GenericDomain2D::GenericDomain2D(const unsigned int& _globalId, const unsigned int& _totalNumberVertices) : GenericDomain(_globalId, _totalNumberVertices)
	{
		planeTranslation = 0;
		planeNormal.setZero();

		InitializeEdges(totalNumberVertices);
	}
	GenericDomain2D::~GenericDomain2D()
	{
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain2D::Initialize()
	{
		Output::ExitCodes result;

		result = ComputePlane();
		if (result != Output::Success)
			return result;

		SetOriginTranslation(vertices[0]);
		result = ComputeRotationMatrix();
		if (result != Output::Success)
			return result;

		result = RotateVertices(vertices);
		if (result != Output::Success)
			return result;

		result = ComputeAreaAndCentroid();
		if (result != Output::Success)
			return result;

		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain2D::ComputePlane()
	{
		/// <ul>
		if (NumberEdges() != TotalNumberEdges())
		{
			Output::PrintWarningMessage("Impossible to compute the geometric properties of domain %d. It has %d edges, expected %d.", false, globalId, NumberEdges(), TotalNumberEdges());
			return Output::GenericError;
		}

		/// <li> Compute normal vector N
		planeNormal.setZero();
		for(unsigned int i = 0; i < totalNumberEdges; i++)
		{
			int previousEdgeIndex = (i == 0) ? totalNumberEdges - 1 : i - 1;

			Vector3d edgeOne = Vertex(EdgeEndIndex(i)) - Vertex(EdgeOriginIndex(i));
			Vector3d edgeTwo = Vertex(EdgeOriginIndex(previousEdgeIndex)) - Vertex(EdgeEndIndex(previousEdgeIndex));

			planeNormal.noalias() += edgeOne.cross(edgeTwo);
		}
		planeNormal.normalize();

		/// <li> Compute d
		planeTranslation = planeNormal.dot(vertices[0]);

		return Output::Success;

		/// </ul>
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain2D::ComputeRotationMatrix(const double& rotationTolerance)
	{
		if (NumberVertices() != TotalNumberVertices())
		{
			Output::PrintWarningMessage("Impossible to compute the geometric properties of domain %d. It has %d vertices, expected %d.", false, globalId, NumberVertices(), TotalNumberVertices());
			return Output::GenericError;
		}

		MatrixXd Z(3, totalNumberVertices);
		MatrixXd W(3, totalNumberVertices);
		Matrix3d H;
		Vector3d V1mV0 = vertices[1] - vertices[0];

		for (unsigned int i = 1; i < totalNumberVertices; i++)
		{
			Vector3d VimV0 = vertices[i] - vertices[0];
			Z.col(i - 1) = VimV0;

			double normVector = VimV0.norm();
			double angleBetweenVectors = ((VimV0 - V1mV0).norm() < rotationTolerance) ? 0.0 : acos(VimV0.dot(V1mV0) / (normVector * V1mV0.norm()));
			W.col(i - 1) << normVector * cos(angleBetweenVectors), normVector * sin(angleBetweenVectors), 0;
		}

		Z.col(totalNumberVertices - 1) = planeNormal;
		W.col(totalNumberVertices - 1)<< 0, 0, 1;
		H = W * Z.transpose();
		JacobiSVD<MatrixXd> svd(H, ComputeThinU | ComputeThinV);
		rotationMatrix = svd.matrixV() * (svd.matrixU()).transpose();

		return Output::Success;
	}
	// ***************************************************************************
	Output::ExitCodes GenericDomain2D::ComputeAreaAndCentroid(const double& areaTolerance)
	{
		if (NumberRotatedVertices() != TotalNumberVertices())
		{
			Output::PrintWarningMessage("Impossible to compute the geometric properties of domain %d. It has %d vertices, expected %d.", false, globalId, NumberVertices(), TotalNumberVertices());
			return Output::GenericError;
		}

		for (unsigned int i = 0; i < totalNumberVertices; i++)
		{
			const Vector3d& vertex = rotatedVertices[i];
			const Vector3d& nextVertex = rotatedVertices[(i + 1) % totalNumberVertices];

			double localArea = vertex(0) * nextVertex(1) - nextVertex(0) * vertex(1);

			measure += localArea;
			centroid(0) += (vertex(0) + nextVertex(0)) * localArea;
			centroid(1) += (vertex(1) + nextVertex(1)) * localArea;
		}

		if (fabs(measure) < areaTolerance)
		{
			Output::PrintErrorMessage("Domain %d has area too small: %.2e - tolerance %.2e", false, globalId, measure, areaTolerance);
			return Output::GenericError;
		}

		measure /= 2.0;
		centroid /=	(6.0 * measure);
		measure = (measure >= 0.0) ? measure : -1.0 * measure;

		centroid = RotatePoint(centroid, true);

		return Output::Success;
	}
	// ***************************************************************************
	// GenericDomain3D Implementation
	// ***************************************************************************
	GenericDomain3D::GenericDomain3D(const unsigned int& _globalId, const unsigned int& _totalNumberVertices, const unsigned int& _totalNumberEdges, const unsigned int& _totalNumberFaces) : GenericDomain(_globalId, _totalNumberVertices)
	{
		if (_totalNumberEdges == 0 || _totalNumberFaces == 0)
		{
			Output::PrintWarningMessage("Impossible to create domain %d with zero edges or faces", false, _globalId);
			return;
		}

		InitializeEdges(_totalNumberEdges);
		InitializeFaces(_totalNumberFaces);
	}
	GenericDomain3D::~GenericDomain3D()
	{
	}
}
