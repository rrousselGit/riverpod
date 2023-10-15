import React from "react";
import PropTypes from "prop-types";
import CodeBlock from "@theme/CodeBlock";
import "./DocuCode.scss";

type AnnotatedCode = {
  color?: string;
  code: string;
};

export const colors = [
  "#2196f3",
  "#4caf50",
  "#f44336",
  "#ff9800",
  "#009688",
  "#e91e63",
  "#00bcd4",
  "#8bc34a",
];

const Legend = ({ annotations, code }) => {
  const fullAnnotations = new Array<AnnotatedCode>();

  let annotationOffset = 0;
  for (var codeOffset = 0; codeOffset < code.length; ) {
    if (annotationOffset >= annotations.length) {
      // Out of annotations, just add the rest of the code
      fullAnnotations.push({ code: code.substring(codeOffset) });
      break;
    }

    const annotation = annotations[annotationOffset];
    if (codeOffset < annotation.offset) {
      /// There is an unannotated gap between the last annotation and this one.
      const codeLength = annotation.offset - codeOffset;
      fullAnnotations.push({
        code: code.substring(codeOffset, codeOffset + codeLength),
      });
      codeOffset += codeLength;
    }

    if (annotation.offset >= code.length) {
      throw new Error("Annotation offset out of bounds");
    }

    annotationOffset++;
    codeOffset = annotation.offset + annotation.length;
    fullAnnotations.push({
      color: colors[annotationOffset - 1],
      code: code.substring(
        annotation.offset,
        annotation.offset + annotation.length
      ),
    });
  }

  return (
    <div className="legend">
      <pre className="code">
        {fullAnnotations.map(({ code, color }) => {
          let underlineClass = color ? `underline` : "";
          let style = color ? { color: color } : undefined;

          return (
            <span key={code} className={underlineClass} style={style}>
              {code}
            </span>
          );
        })}
      </pre>
      <table className="annotations">
        <tbody>
          {annotations.map((annotation, index) => (
            <tr key={annotation.label} className="annotation">
              <td className="underline" style={{ color: colors[index] }}>
                {annotation.label}
              </td>
              <td>{annotation.description}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Legend;
