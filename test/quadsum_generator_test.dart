// Unit tests: QuadsumGenerator
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/quadsum_generator.dart';

void main() {
  group('QuadsumGenerator.generate', () {
    test('generates valid 3x3 permutation containing digits 1..9 with correct sums', () {
      final config = QuadsumGenerator.generate(
        level: 1,
        revealedCount: 4,
        timeLimit: 120,
        difficulty: 'Beginner',
      );

      expect(config.level, 1);
      expect(config.difficulty, 'Beginner');
      expect(config.timeLimit, 120);

      // Verify all numbers 1..9 exist in solution
      final flat = config.solution.expand((row) => row).toList();
      expect(flat.length, 9);
      expect(flat.toSet().length, 9);
      for (int d = 1; d <= 9; d++) {
        expect(flat.contains(d), isTrue);
      }

      // Verify sum calculations
      final sol = config.solution;
      expect(config.sumTopLeft, sol[0][0] + sol[0][1] + sol[1][0] + sol[1][1]);
      expect(config.sumTopRight, sol[0][1] + sol[0][2] + sol[1][1] + sol[1][2]);
      expect(config.sumBottomLeft, sol[1][0] + sol[1][1] + sol[2][0] + sol[2][1]);
      expect(config.sumBottomRight, sol[1][1] + sol[1][2] + sol[2][1] + sol[2][2]);

      // Verify initial grid revealed clues
      int nonZeroCount = 0;
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          if (config.initialGrid[r][c] > 0) {
            nonZeroCount++;
            expect(config.initialGrid[r][c], config.solution[r][c]);
          }
        }
      }
      expect(nonZeroCount, config.revealedCount);

      // Verify isCompleteSolution helper
      expect(
        QuadsumGenerator.isCompleteSolution(
          grid: config.solution,
          sumTL: config.sumTopLeft,
          sumTR: config.sumTopRight,
          sumBL: config.sumBottomLeft,
          sumBR: config.sumBottomRight,
        ),
        isTrue,
      );
    });

    test('deterministic generation for same level', () {
      final c1 = QuadsumGenerator.generate(
        level: 42,
        revealedCount: 3,
        timeLimit: 180,
        difficulty: 'Medium',
      );
      final c2 = QuadsumGenerator.generate(
        level: 42,
        revealedCount: 3,
        timeLimit: 180,
        difficulty: 'Medium',
      );

      expect(c1.solution, c2.solution);
      expect(c1.sumTopLeft, c2.sumTopLeft);
      expect(c1.sumTopRight, c2.sumTopRight);
      expect(c1.sumBottomLeft, c2.sumBottomLeft);
      expect(c1.sumBottomRight, c2.sumBottomRight);
      expect(c1.initialGrid, c2.initialGrid);
    });
  });

  group('QuadsumGenerator.isCompleteSolution', () {
    test('returns false when grid has duplicate numbers or wrong sums', () {
      final config = QuadsumGenerator.generate(
        level: 5,
        revealedCount: 4,
        timeLimit: 120,
        difficulty: 'Beginner',
      );

      // Grid with duplicate numbers
      final invalidGrid = [
        [1, 1, 3],
        [4, 5, 6],
        [7, 8, 9],
      ];

      expect(
        QuadsumGenerator.isCompleteSolution(
          grid: invalidGrid,
          sumTL: config.sumTopLeft,
          sumTR: config.sumTopRight,
          sumBL: config.sumBottomLeft,
          sumBR: config.sumBottomRight,
        ),
        isFalse,
      );
    });
  });
}
