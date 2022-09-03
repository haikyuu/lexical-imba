import { EmojiNode } from "./nodes/emoji-node"
import ExampleTheme from "./themes/example-theme"

const editorConfig =
	theme: ExampleTheme
	onError: do(error) throw error
	nodes: [EmojiNode]

export default editorConfig
