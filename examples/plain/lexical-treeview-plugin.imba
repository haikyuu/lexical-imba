
import TreeView from '@lexical/react/LexicalTreeView'
import React from 'react'
import ReactDOM from 'react-dom'

# const WebTreeView = reactToWebComponent(TreeView, React, ReactDOM);

# customElements.define("lexical-tree-view", WebTreeView);

tag lexical-treeview-plugin
	@observable editor
	def mount
		editor = #context.editor
	@autorun
	def rc
		return unless editor
		const data = 
			viewClassName: "tree-view-output"
			timeTravelPanelClassName: "debug-timetravel-panel"
			timeTravelButtonClassName: "debug-timetravel-button"
			timeTravelPanelSliderClassName: "debug-timetravel-panel-slider"
			timeTravelPanelButtonClassName: "debug-timetravel-panel-button"
			editor: editor
		ReactDOM.render(React.createElement(TreeView, data), $container)
	# "todo: if really needed"
	def render
		<self>
			<div$container>