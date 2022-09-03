import {
	$createLinkNode,
	$isLinkNode,
	LinkNode,
	TOGGLE_LINK_COMMAND,
} from '@lexical/link';
import {
	$getSelection,
	$isElementNode,
	$setSelection,
	COMMAND_PRIORITY_EDITOR,
} from 'lexical';


def toggleLink(url\(string | null))
	const selection = $getSelection()
	$setSelection(selection) unless selection === null
	const sel = $getSelection()
	return if sel === null
	const nodes = sel.extract()
	if url === null
		# Remove LinkNodes
		nodes.forEach do(node)
			const parent = node.getParent()
			if $isLinkNode(parent)
				const children = parent.getChildren()
				for child in children
					parent.insertBefore child
				parent.remove()
	# Add or merge LinkNodes
	else
		if nodes.length === 1
			const firstNode = nodes[0]
			# if the first node is a LinkNode or if its
			# parent is a LinkNode, we update the URL.
			if $isLinkNode(firstNode)
				firstNode.setURL(url)
				return
			else
				const parent = firstNode.getParent()
				# set parent to be the current linkNode
				# so that other nodes in the same parent
				# aren't handled separately below.
				if $isLinkNode(parent)
					parent.setURL(url) 
					return

		let prevParent = null
		let linkNode = null;
		nodes.forEach do(node)
			const parent = node.getParent()
			return if parent === linkNode or parent === null or ($isElementNode(node) and !node.isInline())
			if $isLinkNode parent
				linkNode = parent
				parent.setURL url
				return
			if !parent.is(prevParent)
				prevParent = parent
				linkNode = $createLinkNode(url)
				if $isLinkNode parent
					if node.getPreviousSibling() === null
						parent.insertBefore(linkNode)
					else
						parent.insertAfter(linkNode)
				else
					node.insertBefore(linkNode)
			if $isLinkNode(node)
				if linkNode !== null
					const children = node.getChildren();
					for child in children
						linkNode.append child
				node.remove()
				return
			if linkNode !== null
				linkNode.append(node)

tag lexical-link-plugin
	@observable editor

	def mount
		editor = #context.editor

	# usePlainTextSetup (depends on editor)
	@autorun
	def link-effect
		return unless editor
		unless editor.hasNodes([LinkNode])
			throw new Error 'LinkPlugin: LinkNode not registered on editor'
		editor.registerCommand(TOGGLE_LINK_COMMAND, &, COMMAND_PRIORITY_EDITOR) do(url)
			console.log "link", url
			toggleLink url
			yes
