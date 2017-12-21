#include "Hungarian.h"

VPFloat hungarian(const VVFloat &matrix) {

	int height = matrix.size(), width = matrix[0].size();

	VFloat u(height, 0), v(width, 0);

	VFloat markIndices(width, -1);

	for (int i = 0; i < height; i++) {
		VFloat links(width, -1);
		VFloat mins(width, inf);
		VFloat visited(width, 0);

		int markedI = i, markedJ = -1, j;
		while (markedI != -1) {
			j = -1;
			for (int j1 = 0; j1 < width; j1++)
				if (!visited[j1]) {
					if (matrix[markedI][j1] - u[markedI] - v[j1] < mins[j1]) {
						mins[j1] = matrix[markedI][j1] - u[markedI] - v[j1];
						links[j1] = markedJ;
					}
					if (j == -1 || mins[j1] < mins[j])
						j = j1;
				}

			int delta = mins[j];
			for (int j1 = 0; j1 < width; j1++)
				if (visited[j1]) {
					u[markIndices[j1]] += delta;
					v[j1] -= delta;
				}
				else {
					mins[j1] -= delta;
				}
				u[i] += delta;

				visited[j] = 1;
				markedJ = j;
				markedI = markIndices[j];
		}

		for (; links[j] != -1; j = links[j])
			markIndices[j] = markIndices[links[j]];
		markIndices[j] = i;
	}

	VPFloat result;
	for (int j = 0; j < width; j++)
		if (markIndices[j] != -1)
			result.push_back(PInt(markIndices[j], j));
	return result;
}
