Tests for riverpod_analyzer_utils

They are un a separate project as the analyzer utils tests depend on
riverpod_generator; but riverpod_generator depends on analyzer utils.
Separating them allows bypassing the circular dependency.