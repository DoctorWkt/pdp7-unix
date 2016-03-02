package com.khubla.pdp7parse;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;

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
}
