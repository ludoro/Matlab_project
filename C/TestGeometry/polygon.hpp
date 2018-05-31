#ifndef POLYGON_H
#define POLYGON_H

#include <vector>

#include "GenericDomain.hpp"
#include "Domain2D.hpp"
#include "Eigen"
#include "Output.hpp"

using namespace std;
using namespace Eigen;
using namespace MainApplication;

namespace GeDiM
{
	class GenericDomain2D;
	class Polygon;

	class Polygon : public GenericDomain2D
	{
		protected:
      unsigned int baseIndex; ///< Indices of the base edge
      unsigned int heightIndex; ///< Indices of the height edge
      unsigned int totalNumberVertices;
		public:
			Polygon(const unsigned int& _globalId);
			virtual ~Polygon();

			Output::ExitCodes BuildPolygon(const vector<Vector3d>& vertices);
	};
}


#endif
