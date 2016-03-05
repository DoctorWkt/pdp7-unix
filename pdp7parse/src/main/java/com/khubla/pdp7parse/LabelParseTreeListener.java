package com.khubla.pdp7parse;
/*
* Copyright 2016, Tom Everett <tom@khubla.com>
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTreeListener;
import org.antlr.v4.runtime.tree.TerminalNode;

import com.khubla.pdp7parse.antlr4.pdp7Parser.LabelContext;

public class LabelParseTreeListener implements ParseTreeListener {
   private final PDP7Metadata pdp7Metadata;

   public LabelParseTreeListener(PDP7Metadata pdp7Metadata) {
      this.pdp7Metadata = pdp7Metadata;
   }

   @Override
   public void visitTerminal(TerminalNode node) {
      // TODO Auto-generated method stub
   }

   @Override
   public void visitErrorNode(ErrorNode node) {
      // TODO Auto-generated method stub
   }

   @Override
   public void enterEveryRule(ParserRuleContext ctx) {
      if (ctx instanceof LabelContext) {
         LabelContext labelContext = (LabelContext) ctx;
      }
   }

   @Override
   public void exitEveryRule(ParserRuleContext ctx) {
      // TODO Auto-generated method stub
   }
}
