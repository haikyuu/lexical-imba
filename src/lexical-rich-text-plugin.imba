import {$canShowPlaceholderCurry} from '@lexical/text';
import type {InitialEditorStateType} from './types'
import {registerDragonSupport} from '@lexical/dragon';
import {registerRichText} from '@lexical/rich-text';
import {mergeRegister} from '@lexical/utils';
tag lexical-rich-text-plugin
	prop content-editable
	prop placeholder
	prop initialEditorState\InitialEditorStateType
	
	editor
	showPlaceholder?
	_decorators = []
	def mount
		editor = #context.editor
		rich-text-setup!
		showPlaceholder? = editor.getEditorState!.read($canShowPlaceholderCurry editor.isComposing!)

	# usePlainTextSetup (depends on editor)
	def rich-text-setup
		return unless editor
		editor.registerUpdateListener do({editorState})
			showPlaceholder? = editorState.read($canShowPlaceholderCurry editor.isComposing!)
			imba.commit!
		mergeRegister(
			registerRichText(editor, initialEditorState),
			registerDragonSupport(editor),
		)
		editor.registerDecoratorListener do(nextDecorators)
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
		<self[pos:relative]>
			<{content-editable()}>
			<{placeholder()}> if showPlaceholder?
			# decorators