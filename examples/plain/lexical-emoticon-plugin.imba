import { TextNode } from "lexical";
import {$createEmojiNode} from './nodes/emoji-node'

def emoticonTransform(node)
	const textContent = node.getTextContent()
	# When you type :), we will replace it with an emoji node
	if textContent == ":)"
		node.replace $createEmojiNode("emoji happysmile", "🙂")

tag lexical-emoticon-plugin
	removeTransform\Function
	@observable editor
	def mount
		editor = #context.editor
	def unmount
		removeTransform! if removeTransform
	@autorun
	def emoticon-effect
		return unless editor
		removeTransform = editor.registerNodeTransform TextNode, emoticonTransform

