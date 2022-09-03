import config from './editor-config'
import '../../src/index'

import {$getRoot, $getSelection} from 'lexical';

const {theme, onError, nodes} = config

tag plain-editor
	editor
	def onc
		1
	def mount
		editor = $composer.editor
		editor.registerUpdateListener do({editorState})
			editorState.read do
				let sel = $getSelection()
	def ce
		<lexical-content-editable id="ce">
	def placeholder
		<div[c:gray3 of:hidden t:15px l:10px fs:15px us:none d:inline-block pe:none pos:absolute text-overflow:ellipsis]>
			"Enter some plain text..."
	def render
		<self>
			<lexical-composer$composer theme=theme onError=onError nodes=nodes>
				# add a plugin to index whenever it's added
				<div[my:20px mx:auto bdr:2px max-width:600px c:black pos:relative lh:20px fw:400 ta:left rdt:10px]>
					<lexical-plain-text-plugin content-editable=ce placeholder=placeholder>
					<lexical-onchange-plugin onChange=onc ignoreSelectionChange>
					<lexical-history-plugin>
					# only replaces emoji when written first (bug in the playground irself)
					# TODO: fix
					<lexical-emoticon-plugin>
					# <lexical-autofocus-plugin>
					<lexical-treeview-plugin>