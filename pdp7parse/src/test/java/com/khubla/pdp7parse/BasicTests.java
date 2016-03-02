package com.khubla.pdp7parse;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Collection;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Test;

import com.khubla.pdp7parse.antlr4.pdp7Parser.ProgContext;

public class BasicTests {
   @Test
   public void test1() {
      String[] extensions = new String[] { "s" };
      Collection<File> files = FileUtils.listFiles(new File("src/test/resources"), extensions, true);
      for (File file : files) {
         testFile(file);
      }
   }

   private void testFile(File file) {
      try {
         System.out.println(file.getAbsolutePath());
         InputStream is = new FileInputStream(file);
         ProgContext progContext = PDP7Parser.parse(is, System.out);
         Assert.assertNotNull(progContext);
      } catch (Exception e) {
         e.printStackTrace();
         Assert.fail();
      }
   }
}
