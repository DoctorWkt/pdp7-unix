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
import java.io.File;
import java.io.FileInputStream;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;

import com.khubla.pdp7parse.antlr4.pdp7Parser.ProgContext;

/**
 * @author tom
 */
public class PDP7Parse {
   public static void main(String[] args) {
      try {
         System.out.println("khubla.com PDP7 Parser");
         /*
          * options
          */
         final Options options = new Options();
         OptionBuilder.withArgName(INPUT_FILE_OPTION);
         OptionBuilder.isRequired();
         OptionBuilder.withType(String.class);
         OptionBuilder.hasArg();
         OptionBuilder.withDescription("file to read");
         final Option ifo = OptionBuilder.create(INPUT_FILE_OPTION);
         options.addOption(ifo);
         /*
          * parse
          */
         final CommandLineParser parser = new PosixParser();
         CommandLine cmd = null;
         try {
            cmd = parser.parse(options, args);
         } catch (final Exception e) {
            e.printStackTrace();
            final HelpFormatter formatter = new HelpFormatter();
            formatter.printHelp("posix", options);
            System.exit(0);
         }
         /*
          * get file
          */
         final String inputFileName = cmd.getOptionValue(INPUT_FILE_OPTION);
         final File inputFile = new File(inputFileName);
         if (inputFile.exists()) {
            ProgContext progContext = PDP7Parser.parse(new FileInputStream(inputFile), System.out);
            PDP7Metadata pdp7Metadata = new PDP7Metadata();
            PDP7Parser.analyse(progContext, pdp7Metadata);
         }
      } catch (final Exception e) {
         e.printStackTrace();
      }
   }

   /**
    * file option
    */
   private static final String INPUT_FILE_OPTION = "file";
}