#ifndef DOMAIN2D_H
#define DOMAIN2D_H

#include <vector>

#include "Eigen"
#include "Output.hpp"
#include "GenericDomain.hpp"

using namespace std;
using namespace Eigen;
using namespace MainApplication;

namespace GeDiM
{
	class GenericDomain2D;
	class Parallelogram;

	/// Parallelepiped as defined in https://en.wikipedia.org/wiki/Parallelogram
	class Parallelogram : public GenericDomain2D
	{
		protected:
      unsigned int baseIndex; ///< Indices of the base edge
      unsigned int heightIndex; ///< Indices of the height edge

		public:
			Parallelogram(const unsigned int& _globalId);
			virtual ~Parallelogram();

			Output::ExitCodes BuildParallelogram(const Vector3d& origin, const Vector3d& lengthVector, const Vector3d& widthVector);
	};
}

#endif // DOMAIN2D_H
