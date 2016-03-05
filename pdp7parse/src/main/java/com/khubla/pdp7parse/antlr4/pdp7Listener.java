// Generated from com/khubla/pdp7parse/antlr4/pdp7.g4 by ANTLR 4.5
package com.khubla.pdp7parse.antlr4;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link pdp7Parser}.
 */
public interface pdp7Listener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#prog}.
	 * @param ctx the parse tree
	 */
	void enterProg(pdp7Parser.ProgContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#prog}.
	 * @param ctx the parse tree
	 */
	void exitProg(pdp7Parser.ProgContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#line}.
	 * @param ctx the parse tree
	 */
	void enterLine(pdp7Parser.LineContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#line}.
	 * @param ctx the parse tree
	 */
	void exitLine(pdp7Parser.LineContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#lineeol}.
	 * @param ctx the parse tree
	 */
	void enterLineeol(pdp7Parser.LineeolContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#lineeol}.
	 * @param ctx the parse tree
	 */
	void exitLineeol(pdp7Parser.LineeolContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#declarations}.
	 * @param ctx the parse tree
	 */
	void enterDeclarations(pdp7Parser.DeclarationsContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#declarations}.
	 * @param ctx the parse tree
	 */
	void exitDeclarations(pdp7Parser.DeclarationsContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#declaration}.
	 * @param ctx the parse tree
	 */
	void enterDeclaration(pdp7Parser.DeclarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#declaration}.
	 * @param ctx the parse tree
	 */
	void exitDeclaration(pdp7Parser.DeclarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#instruction}.
	 * @param ctx the parse tree
	 */
	void enterInstruction(pdp7Parser.InstructionContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#instruction}.
	 * @param ctx the parse tree
	 */
	void exitInstruction(pdp7Parser.InstructionContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#argument}.
	 * @param ctx the parse tree
	 */
	void enterArgument(pdp7Parser.ArgumentContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#argument}.
	 * @param ctx the parse tree
	 */
	void exitArgument(pdp7Parser.ArgumentContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#assignment}.
	 * @param ctx the parse tree
	 */
	void enterAssignment(pdp7Parser.AssignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#assignment}.
	 * @param ctx the parse tree
	 */
	void exitAssignment(pdp7Parser.AssignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#symbol}.
	 * @param ctx the parse tree
	 */
	void enterSymbol(pdp7Parser.SymbolContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#symbol}.
	 * @param ctx the parse tree
	 */
	void exitSymbol(pdp7Parser.SymbolContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression(pdp7Parser.ExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression(pdp7Parser.ExpressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#multiplyingExpression}.
	 * @param ctx the parse tree
	 */
	void enterMultiplyingExpression(pdp7Parser.MultiplyingExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#multiplyingExpression}.
	 * @param ctx the parse tree
	 */
	void exitMultiplyingExpression(pdp7Parser.MultiplyingExpressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#atom}.
	 * @param ctx the parse tree
	 */
	void enterAtom(pdp7Parser.AtomContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#atom}.
	 * @param ctx the parse tree
	 */
	void exitAtom(pdp7Parser.AtomContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#string}.
	 * @param ctx the parse tree
	 */
	void enterString(pdp7Parser.StringContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#string}.
	 * @param ctx the parse tree
	 */
	void exitString(pdp7Parser.StringContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#eol}.
	 * @param ctx the parse tree
	 */
	void enterEol(pdp7Parser.EolContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#eol}.
	 * @param ctx the parse tree
	 */
	void exitEol(pdp7Parser.EolContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#comment}.
	 * @param ctx the parse tree
	 */
	void enterComment(pdp7Parser.CommentContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#comment}.
	 * @param ctx the parse tree
	 */
	void exitComment(pdp7Parser.CommentContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#label}.
	 * @param ctx the parse tree
	 */
	void enterLabel(pdp7Parser.LabelContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#label}.
	 * @param ctx the parse tree
	 */
	void exitLabel(pdp7Parser.LabelContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#variable}.
	 * @param ctx the parse tree
	 */
	void enterVariable(pdp7Parser.VariableContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#variable}.
	 * @param ctx the parse tree
	 */
	void exitVariable(pdp7Parser.VariableContext ctx);
	/**
	 * Enter a parse tree produced by {@link pdp7Parser#opcode}.
	 * @param ctx the parse tree
	 */
	void enterOpcode(pdp7Parser.OpcodeContext ctx);
	/**
	 * Exit a parse tree produced by {@link pdp7Parser#opcode}.
	 * @param ctx the parse tree
	 */
	void exitOpcode(pdp7Parser.OpcodeContext ctx);
}