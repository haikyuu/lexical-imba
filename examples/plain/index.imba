import './rich-editor'
import './plain-editor'
import './themes/playground-theme.css'
global css 
	.editor-paragraph m:0 0 15px 0 pos:relative
	body m:0
	code bg:gray8 c:pink4 p:1px
tag example
	<self[bg:cooler7 c:warm3 h:100% p:4 d:vflex ai:center ff:system-ui m:0]>
		<div[max-width:600px w:100% p:4 d:vflex ai:center]>
			<h1[m:0]> "Plain text example"
			<p[fs:large]> "Note: this is an experimental build of Lexical"
			<rich-editor[w:100%]>
			# <plain-editor[w:100%]>

imba.mount <example>