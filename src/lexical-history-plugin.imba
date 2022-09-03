import { registerHistory, createEmptyHistoryState } from '@lexical/history'
import type {HistoryState} from '@lexical/history';

tag lexical-history-plugin
	@observable prop externalHistoryState\HistoryState
	@observable prop delay\number = 1000
	@observable editor
	@observable historyState\HistoryState
	def mount
		editor = #context.editor
		historyState = externalHistoryState or createEmptyHistoryState()
	@autorun
	def register-history
		return unless editor and historyState
		registerHistory editor, historyState, delay
	
	