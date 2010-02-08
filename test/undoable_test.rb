#!/usr/bin/env macruby 
require "../lib/undoable"
require 'test/unit'

# Hah, UndoableTest. Now that's funny.
class UndoableTest < Test::Unit::TestCase

  class Person
    include Undoable
        
    def initialize(name)
      @name = name
    end
          
    def name; @name end
    def name=(string)
      current_name = self.name
      add_to_undo_stack {|inst| inst.name = current_name}
      @name = string
    end
  end

  def setup
    @person = Person.new 'Lori'  
  end

  def test_undo
    @person.name = 'Erin'
    assert_equal @person.name, 'Erin'
    @person.name = 'Rachel'
    assert_equal @person.name, 'Rachel'
    @person.undo
    assert_equal @person.name, 'Erin'
    @person.undo
    assert_equal @person.name, 'Lori'
  end

  def test_chaining_undos
    @person.name = 'Erin'
    @person.name = 'Rachel'
    @person.undo.undo
    assert_equal @person.name, 'Lori'
  end

  def test_redo
    @person.name = 'Erin'
    @person.undo
    @person.redo
    assert_equal @person.name, 'Erin'
  end

  def test_chaining_redos
    @person.name = 'Erin'
    @person.name = 'Rachel'
    @person.undo.undo
    assert_equal @person.name, 'Lori'
    @person.redo.redo
    assert_equal @person.name, 'Rachel'
  end

  def test_undo?
    assert !@person.undo?
    @person.name = 'Erin'
    assert @person.undo?
  end

  def test_redo?
    @person.name = 'Erin'
    assert !@person.redo?
    @person.undo
    assert @person.redo?
  end

end
