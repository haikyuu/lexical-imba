import { TextNode } from 'lexical';

export class EmojiNode > TextNode
	__className = ""
	static def getType do "emoji"
	static def clone(node)
		new EmojiNode(node.__className, node.__text, node.__key)

	def constructor(className, text, key)
		super(text, key)
		__className = className;
	def createDom(config)
		const inner = super.createDOM(config)
		inner.className = "emoji-inner"
		let dom = <span>
		dom.classList.add __className
		dom.appendChild inner
		dom

	def updateDOM(prevNode, dom, config)
		const inner = dom.firstChild;
		return true if inner === null
		super.updateDOM(prevNode, inner, config)
		no
export def $isEmojiNode do $1 instanceof EmojiNode

export def $createEmojiNode(className, emojiText)
	new EmojiNode(className, emojiText).setMode "token"
