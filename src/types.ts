import type { EditorState, EditorThemeClasses, LexicalEditor } from 'lexical';

export type InitialEditorStateType = (
  | null
  | string
  | EditorState
  | (() => void)
);

export type LexicalComposerContextType = {
  getTheme: () => EditorThemeClasses | null;
};

export type LexicalComposerContextWithEditor = [
  LexicalEditor,
  LexicalComposerContextType,
];
