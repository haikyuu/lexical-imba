import {
	CAN_REDO_COMMAND,
	CAN_UNDO_COMMAND,
	REDO_COMMAND,
	UNDO_COMMAND,
	SELECTION_CHANGE_COMMAND,
	FORMAT_TEXT_COMMAND,
	FORMAT_ELEMENT_COMMAND,
	$getSelection,
	$isRangeSelection,
	$createParagraphNode,
	$getNodeByKey,
} from "lexical";
import { $isLinkNode, TOGGLE_LINK_COMMAND } from "@lexical/link";
import {
	$isParentElementRTL,
	$wrapLeafNodesInElements,
	$isAtNodeEnd,
	$getSelectionStyleValueForProperty,
	$patchStyleText,
} from "@lexical/selection";
import { $getNearestNodeOfType, mergeRegister } from "@lexical/utils";
import {
	INSERT_ORDERED_LIST_COMMAND,
	INSERT_UNORDERED_LIST_COMMAND,
	REMOVE_LIST_COMMAND,
	$isListNode,
	ListNode
} from "@lexical/list";
import {
	$createHeadingNode,
	$createQuoteNode,
	$isHeadingNode
} from "@lexical/rich-text";
import {
	$createCodeNode,
	$isCodeNode,
	getDefaultCodeLanguage,
	getCodeLanguages
} from "@lexical/code";

const LowPriority = 1;
const codeLanguages = getCodeLanguages()
const fonts = [
	'Arial'
	'Courier New'
	'Georgia'
	'Times New Roman'
	'Trebuchet MS'
	'Verdana'
]
const font-sizes = [
	'10px'
	'11px'
	'12px'
	'13px'
	'14px'
	'15px'
	'16px'
	'17px'
	'18px'
	'19px'
	'20px'
]
const supportedBlockTypes = new Set [
	"paragraph"
	"quote"
	"code"
	"h1"
	"h2"
	"ul"
	"ol"
]

const blockTypeToBlockName =
	code: "Code Block"
	h1: "Large Heading"
	h2: "Small Heading"
	h3: "Heading"
	h4: "Heading"
	h5: "Heading"
	ol: "Numbered List"
	paragraph: "Normal"
	quote: "Quote"
	ul: "Bulleted List"

let show-block-options-dropdown? = no
def positionEditorElement(editor, rect)
	if rect === null
		editor.style.opacity = "0"
		editor.style.top = "-1000px"
		editor.style.left = "-1000px"
	else
		editor.style.opacity = "1"
		editor.style.top = `{rect.top + rect.height + window.pageYOffset + 10}px`
		let l = rect.left + window.pageXOffset - editor.offsetWidth / 2 + rect.width / 2
		l = 5 if l < 0
		editor.style.left = `{l}px`
def getSelectedNode(selection)
	const anchor = selection.anchor
	const focus = selection.focus
	const anchorNode = selection.anchor.getNode()
	const focusNode = selection.focus.getNode()
	return anchorNode if anchorNode === focusNode
	const isBackward = selection.isBackward()
	if isBackward
		return $isAtNodeEnd(focus) ? anchorNode : focusNode
	else return $isAtNodeEnd(anchor) ? focusNode : anchorNode

tag floating-link-editor
	prop editor
	linkUrl\string
	edit-mode?\boolean = no
	last-selection
	# editorRef = self
	def onEnter
		if last-selection !== null
			editor.dispatchCommand(TOGGLE_LINK_COMMAND, linkUrl) if linkUrl !== ""
			edit-mode? = no
	def updateLinkEditor
		const selection = $getSelection();
		if $isRangeSelection(selection)
			const node = getSelectedNode(selection);
			const parent = node.getParent();
			if $isLinkNode(parent)
				console.log "p", parent.getURL()		
				linkUrl = parent.getURL()
			elif $isLinkNode(node)
				console.log "n", node.getURL()
				linkUrl = node.getURL()
			else 
				linkUrl = ""
		const editorElem = self
		const nativeSelection = window.getSelection();
		const activeElement = document.activeElement;
		const rootElement = editor.getRootElement();
		if selection !== null and !nativeSelection.isCollapsed and rootElement !== null and rootElement.contains(nativeSelection.anchorNode)
			const domRange = nativeSelection.getRangeAt(0);
			let rect;
			if nativeSelection.anchorNode === rootElement
				let inner = rootElement
				while inner.firstElementChild != null
					inner = inner.firstElementChild
				rect = inner.getBoundingClientRect()
			else
				rect = domRange.getBoundingClientRect()
			positionEditorElement(editorElem, rect)
			last-selection = selection
		elif !activeElement or activeElement.className !== "link-input"
			positionEditorElement(editorElem, null);
			last-selection = null
			edit-mode? = no
			linkUrl = ""
		imba.commit!

	def mount
		mergeRegister(
			editor.registerUpdateListener(do({ editorState }) editorState.read do updateLinkEditor!; yes),
			editor.registerCommand(SELECTION_CHANGE_COMMAND, (do updateLinkEditor!; yes), LowPriority)
		)
		editor.getEditorState().read do updateLinkEditor!
		$inputRef.focus() if edit-mode?
	def render
		<self.link-editor>
			if edit-mode?
				<input$inputRef.link-input bind=linkUrl @keydown.enter.prevent=onEnter @keydown.esc.prevent=(edit-mode? = no)>
			else
				<.link-input>
					<a href=linkUrl target="_blank" rel="noopener noreferrer"> linkUrl
					<.link-edit role="button" tabIndex=0 @mousedown.prevent @click=(edit-mode? = yes)>
tag floating-link-editor-select
	<self>
		<select @change>


tag block-options-dropdown-list
	prop editor
	prop block-type
	prop toolbarRef
	def formatParagraph
		if block-type !== "paragraph"
			editor.update do
				const selection = $getSelection();
				if $isRangeSelection(selection)
					$wrapLeafNodesInElements selection, do $createParagraphNode()
		show-block-options-dropdown? = no

	def formatLargeHeading
		if block-type !== "h1"
			editor.update do
				const selection = $getSelection();
				if $isRangeSelection(selection)
					$wrapLeafNodesInElements selection, do  $createHeadingNode("h1")
		show-block-options-dropdown? = no

	def formatSmallHeading
		if block-type !== "h2"
			editor.update do
				const selection = $getSelection();
				if $isRangeSelection(selection)
					$wrapLeafNodesInElements selection, do  $createHeadingNode("h2")
		show-block-options-dropdown? = no
	def formatBulletList
		if block-type !== "ul"
			editor.dispatchCommand(INSERT_UNORDERED_LIST_COMMAND)
		else
			editor.dispatchCommand(REMOVE_LIST_COMMAND)
		show-block-options-dropdown? = no
	def formatNumberedList
		if block-type !== "ol"
			editor.dispatchCommand(INSERT_ORDERED_LIST_COMMAND)
		else
			editor.dispatchCommand(REMOVE_LIST_COMMAND)
		show-block-options-dropdown? = no
	def formatQuote
		if block-type !== "quote"
			editor.update do
				const selection = $getSelection();
				if $isRangeSelection(selection)
					$wrapLeafNodesInElements selection, do  $createQuoteNode!
		show-block-options-dropdown? = no
	def formatCode
		if block-type !== "code"
			editor.update do
				const selection = $getSelection();
				if $isRangeSelection(selection)
					$wrapLeafNodesInElements selection, do  $createCodeNode!
		show-block-options-dropdown? = no
	def onClick(e)
		if !self.contains(e.target) and !toolbarRef.contains(e.target)
				show-block-options-dropdown? = no
	def render
		const { top, left } = toolbarRef.getBoundingClientRect()
		<self.dropdown[t:{top + 40}px l:{left}px]>
			<global @click=onClick>
			<button.item @click=formatParagraph>
				<span.icon.paragraph>
				<span.text> "Normal"
				<span.active> if block-type === "paragraph"

			<button.item @click=formatLargeHeading>
				<span.icon.large-heading>
				<span.text> "Large Heading"
				<span.active> if block-type === "h1"

			<button.item @click=formatSmallHeading>
				<span.icon.small-heading>
				<span.text> "Small Heading"
				<span.active> if block-type === "h2"

			<button.item @click=formatBulletList>
				<span.icon.bullet-list>
				<span.text> "Bullet List"
				<span.active> if block-type === "ul"

			<button.item @click=formatNumberedList>
				<span.icon.numbered-list>
				<span.text> "Numbered List"
				<span.active> if block-type === "ol"

			<button.item @click=formatQuote>
				<span.icon.quote>
				<span.text> "Quote"
				<span.active> if block-type === "quote"
			
			<button.item @click=formatCode>
				<span.icon.code>
				<span.text> "Code Block"
				<span.active> if block-type === "code"


tag lexical-toolbar-plugin
	editor
	can-undo?\boolean = no
	can-redo?\boolean = no
	block-type = "paragraph"
	selected-element-key = null
	code-lang = ""
	rtl? = no
	link? = no
	bold? = no
	font-size = "15px"
	font-family = "Arial"
	font-color = "#000"
	font-bg = "#fff"
	italic? = no
	underline? = no
	striked? = no
	code? = no
	def mount
		editor = #context.editor
		mergeRegister(
			editor.registerUpdateListener(do({editorState}) editorState.read(do updateToolbar!)),
			editor.registerCommand(SELECTION_CHANGE_COMMAND, (do updateToolbar!; no), LowPriority),
			editor.registerCommand(CAN_UNDO_COMMAND, (do can-undo? = $1; no), LowPriority),
			editor.registerCommand(CAN_REDO_COMMAND, (do can-redo? = $1; no), LowPriority),
		)
	def updateToolbar
		const selection = $getSelection();
		return unless $isRangeSelection(selection)
		const anchorNode = selection.anchor.getNode()
		const element = anchorNode.getKey() === "root" ? anchorNode : anchorNode.getTopLevelElementOrThrow()
		const elementKey = element.getKey()
		const elementDOM = editor.getElementByKey(elementKey)
		if elementDOM !== null
			selected-element-key = elementKey
			if $isListNode(element)
				const parentList = $getNearestNodeOfType(anchorNode, ListNode);
				const type = parentList ? parentList.getTag() : element.getTag();
				block-type = type
			else
				const type = $isHeadingNode(element) ? element.getTag() : element.getType()
				block-type = type
				if $isCodeNode(element)
					code-lang = (element.getLanguage() or getDefaultCodeLanguage())
		# Update text format
		bold? = selection.hasFormat("bold")
		italic? = selection.hasFormat("italic")
		underline? = selection.hasFormat("underline")
		striked? = selection.hasFormat("strikethrough")
		code? = selection.hasFormat("code")
		rtl? = $isParentElementRTL(selection)

		# Update links
		const node = getSelectedNode(selection);
		const parent = node.getParent();
		link? = $isLinkNode(parent) or $isLinkNode(node)

		# handle buttons
		font-size = $getSelectionStyleValueForProperty(selection, 'font-size', '15px')
		font-color = $getSelectionStyleValueForProperty(selection, 'color', '#000')
		bg-color = $getSelectionStyleValueForProperty(selection, 'background-color', "#fff")
		font-family = $getSelectionStyleValueForProperty(selection, 'font-family', 'Arial')
	def insertLink
		editor.dispatchCommand(TOGGLE_LINK_COMMAND, link? ? null : "https://")

	def onCodeLanguageSelect(e)
		editor.update do
			if selected-element-key !== null
				const node = $getNodeByKey(selected-element-key)
				node.setLanguage(e.target.value) if $isCodeNode(node)
	def applyStyleText(styles\(Record<string, string>))
		editor.update do
			const selection = $getSelection()
			$patchStyleText(selection, styles) if $isRangeSelection selection
	def render
		<self.toolbar>
			<button.toolbar-item.spaced disabled=(!can-undo?) @click=editor.dispatchCommand(UNDO_COMMAND) aria-label="Undo">
				<i.format.undo>
			<button.toolbar-item.spaced disabled=(!can-undo?) @click=editor.dispatchCommand(REDO_COMMAND) aria-label="Redo">
				<i.format.redo>
			<.divider>
			if supportedBlockTypes.has(block-type)
				<button.toolbar-item.block-controls @click=(show-block-options-dropdown? = !show-block-options-dropdown?) aria-label="Formatting Options">
					<span.icon className="block-type {block-type}">
					<span.text> blockTypeToBlockName[block-type]
					<i.chevron-down>
				if show-block-options-dropdown?
					<teleport to="body">
						<block-options-dropdown-list editor=editor block-type=block-type toolbarRef=self>
			<.divider>
			if block-type === "code"
				<>
					<select.toolbar-item @change=onCodeLanguageSelect bind=code-lang>
						<option hidden=yes value="">
						for option in codeLanguages
							<option value=option> option
					<div> <i.chevron-down.inside>
			else
				<>
					<>
						<select.toolbar-item.font-family[w:90px pr:8] @change=applyStyleText("font-family": e.target.value) bind=font-family>
							<option hidden=yes value="">
							for option in fonts
								<option value=option> option
						<div> <i.chevron-down.inside>
					<>
						<select.toolbar-item.font-size[w:80px pr:8] @change=applyStyleText("font-size": e.target.value) bind=font-size>
							<option hidden=yes value="">
							for option in font-sizes
								<option value=option> option
						<div> <i.chevron-down.inside>
					<.divider>
					<button.toolbar-item.spaced .active=bold? @click=editor.dispatchCommand(FORMAT_TEXT_COMMAND, "bold") aria-label="Format Bold">
						<i.format.bold>
					<button.toolbar-item.spaced .active=italic? @click=editor.dispatchCommand(FORMAT_TEXT_COMMAND, "italic") aria-label="Format Italic">
						<i.format.italic>
					<button.toolbar-item.spaced .active=underline? @click=editor.dispatchCommand(FORMAT_TEXT_COMMAND, "underline") aria-label="Format Underline">
						<i.format.underline>
					<button.toolbar-item.spaced .active=striked? @click=editor.dispatchCommand(FORMAT_TEXT_COMMAND, "strikethrough") aria-label="Format Strikethrough">
						<i.format.strikethrough>
					<button.toolbar-item.spaced .active=code? @click=editor.dispatchCommand(FORMAT_TEXT_COMMAND, "code") aria-label="Insert Code">
						<i.format.code>
					<button.toolbar-item.spaced .active=link? @click=insertLink aria-label="Insert Link">
						<i.format.link>
					if link?
						<global> 
							<floating-link-editor editor=editor>
					<.divider>
					<button.toolbar-item.spaced @click=editor.dispatchCommand(FORMAT_ELEMENT_COMMAND, "left") aria-label="Left Align">
						<i.format.left-align>
					<button.toolbar-item.spaced @click=editor.dispatchCommand(FORMAT_ELEMENT_COMMAND, "center") aria-label="Center Align">
						<i.format.center-align>
					<button.toolbar-item.spaced @click=editor.dispatchCommand(FORMAT_ELEMENT_COMMAND, "right") aria-label="Right Align">
						<i.format.right-align>
					<button.toolbar-item.spaced @click=editor.dispatchCommand(FORMAT_ELEMENT_COMMAND, "justify") aria-label="Justify Align">
						<i.format.justify-align>
