import {$canShowPlaceholderCurry} from '@lexical/text';
import type {InitialEditorStateType} from './types'
import {registerDragonSupport} from '@lexical/dragon';
import {registerPlainText} from '@lexical/plain-text';
import {mergeRegister} from '@lexical/utils';

tag lexical-plain-text-plugin
	prop content-editable
	prop placeholder
	prop initialEditorState\InitialEditorStateType
	
	@observable editor
	showPlaceholder?
	def mount
		editor = #context.editor
		showPlaceholder? = editor.getEditorState!.read($canShowPlaceholderCurry editor.isComposing!)
	@observable _decorators = []

	# usePlainTextSetup (depends on editor)
	@autorun
	def plain-text-setup
		return unless editor
		editor.registerUpdateListener do({editorState})
			showPlaceholder? = editorState.read($canShowPlaceholderCurry editor.isComposing!)
			imba.commit!
		mergeRegister(
			registerPlainText(editor, initialEditorState),
			registerDragonSupport(editor),
		)
	
	# decorators
	@autorun
	def subscribe-to-changes
		#context.editor.registerDecoratorListener do(nextDecorators)
			_decorators = nextDecorators
			imba.commit!
	
	get decorators
		const decoratedPortals = [];
		const decoratorKeys = Object.keys(_decorators);
		for _, i in decoratorKeys
			const nodeKey = decoratorKeys[i]
			const dec = _decorators[nodeKey]
			const element = editor.getElementByKey nodeKey
			if element !== null
				decoratedPortals.push(<teleport to=element> dec)
		imba.commit!
		decoratedPortals

	def render
		<self>
			<{content-editable()}[min-height:150px resize:none fs:15px caret-color:pink3 pos:relative tab-size:1 outline:0 py:15px px:10px bgc:cooler7 c:white]>
			<{placeholder()}> if showPlaceholder?
			# decorators