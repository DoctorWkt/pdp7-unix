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

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import com.khubla.pdp7parse.antlr4.pdp7Lexer;
import com.khubla.pdp7parse.antlr4.pdp7Parser;
import com.khubla.pdp7parse.antlr4.pdp7Parser.ProgContext;

public class PDP7Parser {
   public static ProgContext parse(InputStream inputStream, OutputStream outputStream) throws Exception {
      try {
         if (null != inputStream) {
            final Reader reader = new InputStreamReader(inputStream, "UTF-8");
            final pdp7Lexer lexer = new pdp7Lexer(new ANTLRInputStream(reader));
            final CommonTokenStream commonTokenStream = new CommonTokenStream(lexer);
            final pdp7Parser parser = new pdp7Parser(commonTokenStream);
            return parser.prog();
         } else {
            throw new IllegalArgumentException();
         }
      } catch (final Exception e) {
         throw new Exception("Exception reading and parsing file", e);
      }
   }

   public static void analyse(ProgContext progContext, PDP7Metadata pdp7Metadata) {
      ParseTreeWalker parseTreeWalker = new ParseTreeWalker();
      parseTreeWalker.walk(new LabelParseTreeListener(pdp7Metadata), progContext);
   }
}
