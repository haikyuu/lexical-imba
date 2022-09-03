import { $getListDepth, $isListItemNode, $isListNode } from "@lexical/list";
import {
	$getSelection,
	$isElementNode,
	$isRangeSelection,
	INDENT_CONTENT_COMMAND,
	COMMAND_PRIORITY_HIGH
} from "lexical";

def getElementNodesInSelection(selection)
	const nodesInSelection = selection.getNodes()
	if nodesInSelection.length === 0
		new Set [
			selection.anchor.getNode().getParentOrThrow(),
			selection.focus.getNode().getParentOrThrow()
		]
	else
		new Set(nodesInSelection.map do(n) $isElementNode(n) ? n : n.getParentOrThrow())


def isIndentPermitted(maxDepth\number)
	const selection = $getSelection()
	return no if !$isRangeSelection(selection)

	const elementNodesInSelection = getElementNodesInSelection(selection);

	let totalDepth = 0

	for elementNode of elementNodesInSelection
		if $isListNode(elementNode)
			totalDepth = Math.max($getListDepth(elementNode) + 1, totalDepth)
		elif $isListItemNode(elementNode)
			const parent = elementNode.getParent();
			if !$isListNode(parent)
				throw new Error "ListMaxIndentLevelPlugin: A ListItemNode must have a ListNode for a parent."

			totalDepth = Math.max($getListDepth(parent) + 1, totalDepth)
	totalDepth <= maxDepth

tag lexical-list-max-indent-level-plugin
	@observable editor
	@observable prop max-depth\number
	def mount
		editor = #context.editor

	@autorun
	def list-max-indent-effect
		return unless editor
		editor.registerCommand(INDENT_CONTENT_COMMAND, &, COMMAND_PRIORITY_HIGH) do
			!isIndentPermitted(max-depth ?? 7)
