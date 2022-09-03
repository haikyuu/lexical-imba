import {ListItemNode, ListNode} from '@lexical/list';
import type {LexicalEditor} from 'lexical';

import {
	$handleListInsertParagraph,
	indentList,
	INSERT_ORDERED_LIST_COMMAND,
	INSERT_UNORDERED_LIST_COMMAND,
	insertList,
	outdentList,
	REMOVE_LIST_COMMAND,
	removeList,
} from '@lexical/list';
import {mergeRegister} from '@lexical/utils';
import {
	COMMAND_PRIORITY_LOW,
	INDENT_CONTENT_COMMAND,
	INSERT_PARAGRAPH_COMMAND,
	OUTDENT_CONTENT_COMMAND,
} from 'lexical';

tag lexical-list-plugin
	@observable editor

	def mount
		editor = #context.editor

	# usePlainTextSetup (depends on editor)
	@autorun
	def list-effect
		return unless editor
		unless editor.hasNodes([ListNode, ListItemNode])
			throw new Error 'ListPlugin: ListNode and/or ListItemNode not registered on editor'
		mergeRegister(
			editor.registerCommand(INDENT_CONTENT_COMMAND, &, COMMAND_PRIORITY_LOW) do indentList!; no
			editor.registerCommand(OUTDENT_CONTENT_COMMAND, &, COMMAND_PRIORITY_LOW) do outdentList!; no
			editor.registerCommand(INSERT_ORDERED_LIST_COMMAND, &, COMMAND_PRIORITY_LOW) do insertList(editor, 'number'); yes
			editor.registerCommand(INSERT_UNORDERED_LIST_COMMAND, &, COMMAND_PRIORITY_LOW) do insertList(editor, 'bullet'); yes
			editor.registerCommand(REMOVE_LIST_COMMAND, &, COMMAND_PRIORITY_LOW) do removeList(editor); yes
			editor.registerCommand(INSERT_PARAGRAPH_COMMAND, &, COMMAND_PRIORITY_LOW) do !!$handleListInsertParagraph()
		)