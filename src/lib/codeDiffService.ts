import DiffMatchPatch from 'diff-match-patch';

export interface DiffLine {
  type: 'equal' | 'insert' | 'delete';
  text: string;
  lineNumber1?: number; // Line number in old code
  lineNumber2?: number; // Line number in new code
}

export interface SideBySideDiff {
  left: DiffLine[];
  right: DiffLine[];
}

class CodeDiffService {
  private dmp: DiffMatchPatch;

  constructor() {
    this.dmp = new DiffMatchPatch();
  }

  /**
   * Generate side-by-side diff for code comparison
   */
  generateSideBySideDiff(oldCode: string, newCode: string): SideBySideDiff {
    const diffs = this.dmp.diff_main(oldCode, newCode);
    this.dmp.diff_cleanupSemantic(diffs);

    const left: DiffLine[] = [];
    const right: DiffLine[] = [];
    let leftLineNum = 1;
    let rightLineNum = 1;

    for (const [operation, text] of diffs) {
      const lines = text.split('\n');

      if (operation === 0) {
        // Equal - show on both sides
        lines.forEach((line, index) => {
          const isLastLine = index === lines.length - 1;
          if (!isLastLine || line !== '') {
            left.push({
              type: 'equal',
              text: line,
              lineNumber1: leftLineNum++,
              lineNumber2: rightLineNum,
            });
            right.push({
              type: 'equal',
              text: line,
              lineNumber1: leftLineNum - 1,
              lineNumber2: rightLineNum++,
            });
          }
        });
      } else if (operation === -1) {
        // Deletion - show only on left
        lines.forEach((line, index) => {
          const isLastLine = index === lines.length - 1;
          if (!isLastLine || line !== '') {
            left.push({
              type: 'delete',
              text: line,
              lineNumber1: leftLineNum++,
            });
            right.push({
              type: 'delete',
              text: '',
              lineNumber2: rightLineNum,
            });
          }
        });
      } else {
        // Insertion - show only on right
        lines.forEach((line, index) => {
          const isLastLine = index === lines.length - 1;
          if (!isLastLine || line !== '') {
            left.push({
              type: 'insert',
              text: '',
              lineNumber1: leftLineNum,
            });
            right.push({
              type: 'insert',
              text: line,
              lineNumber2: rightLineNum++,
            });
          }
        });
      }
    }

    return { left, right };
  }

  /**
   * Generate unified diff (single column with +/- markers)
   */
  generateUnifiedDiff(oldCode: string, newCode: string): string {
    const diffs = this.dmp.diff_main(oldCode, newCode);
    this.dmp.diff_cleanupSemantic(diffs);

    let result = '';
    for (const [operation, text] of diffs) {
      if (operation === 0) {
        // Equal - no prefix
        result += text;
      } else if (operation === -1) {
        // Deletion - prefix with -
        const lines = text.split('\n');
        result += lines.map(line => `- ${line}`).join('\n') + '\n';
      } else {
        // Insertion - prefix with +
        const lines = text.split('\n');
        result += lines.map(line => `+ ${line}`).join('\n') + '\n';
      }
    }

    return result;
  }

  /**
   * Calculate similarity percentage between two code strings
   */
  calculateSimilarity(oldCode: string, newCode: string): number {
    const diffs = this.dmp.diff_main(oldCode, newCode);
    const levenshteinDistance = this.dmp.diff_levenshtein(diffs);
    const maxLength = Math.max(oldCode.length, newCode.length);
    
    if (maxLength === 0) return 100;
    
    const similarity = ((maxLength - levenshteinDistance) / maxLength) * 100;
    return Math.round(similarity * 100) / 100;
  }

  /**
   * Get summary of changes
   */
  getChangeSummary(oldCode: string, newCode: string): {
    additions: number;
    deletions: number;
    totalChanges: number;
  } {
    const diffs = this.dmp.diff_main(oldCode, newCode);
    
    let additions = 0;
    let deletions = 0;

    for (const [operation, text] of diffs) {
      const lineCount = text.split('\n').length - 1;
      if (operation === 1) {
        additions += lineCount;
      } else if (operation === -1) {
        deletions += lineCount;
      }
    }

    return {
      additions,
      deletions,
      totalChanges: additions + deletions,
    };
  }

  /**
   * Generate inline diff with character-level highlighting
   */
  generateInlineDiff(oldCode: string, newCode: string): Array<{
    type: 'equal' | 'insert' | 'delete';
    text: string;
  }> {
    const diffs = this.dmp.diff_main(oldCode, newCode);
    this.dmp.diff_cleanupSemantic(diffs);

    return diffs.map(([operation, text]) => ({
      type: operation === 0 ? 'equal' : operation === 1 ? 'insert' : 'delete',
      text,
    }));
  }

  /**
   * Create HTML diff (for rendering in a rich text editor)
   */
  createHTMLDiff(oldCode: string, newCode: string): string {
    const diffs = this.dmp.diff_main(oldCode, newCode);
    this.dmp.diff_cleanupSemantic(diffs);
    return this.dmp.diff_prettyHtml(diffs);
  }

  /**
   * Find the longest common subsequence
   */
  findCommonCode(oldCode: string, newCode: string): string {
    const diffs = this.dmp.diff_main(oldCode, newCode);
    return diffs
      .filter(([operation]) => operation === 0)
      .map(([, text]) => text)
      .join('');
  }

  /**
   * Get line-by-line diff statistics
   */
  getLineStats(oldCode: string, newCode: string): {
    oldLines: number;
    newLines: number;
    unchangedLines: number;
    changedLines: number;
  } {
    const oldLines = oldCode.split('\n').length;
    const newLines = newCode.split('\n').length;
    const diffs = this.dmp.diff_main(oldCode, newCode);
    
    let unchangedLines = 0;
    for (const [operation, text] of diffs) {
      if (operation === 0) {
        unchangedLines += text.split('\n').length - 1;
      }
    }

    return {
      oldLines,
      newLines,
      unchangedLines,
      changedLines: Math.max(oldLines, newLines) - unchangedLines,
    };
  }
}

export const codeDiffService = new CodeDiffService();
