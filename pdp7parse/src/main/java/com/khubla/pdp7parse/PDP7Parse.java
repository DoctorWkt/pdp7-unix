package com.khubla.pdp7parse;

import java.io.File;
import java.io.FileInputStream;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;

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
            PDP7Parser.parse(new FileInputStream(inputFile), System.out);
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