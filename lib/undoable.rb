# Requiring Foundation makes #undo? and #redo?
# return true/false instead of 1/0.
framework 'Foundation'

module Undoable
  def undo; undo_manager.undo end
  def redo; undo_manager.redo end 

  def undo?; undo_manager.canUndo end
  def redo?; undo_manager.canRedo end

  private

  def undo_manager
    @undo_manager ||= ::NSUndoManager.new.setGroupsByEvent(false)
  end
  
  def add_to_undo_stack
    begin
      undo_manager.beginUndoGrouping
      yield undo_manager.prepareWithInvocationTarget(self)
    ensure
      undo_manager.endUndoGrouping
    end
  end


end
