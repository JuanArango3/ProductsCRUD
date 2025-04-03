package me.jmarango.productscrud.utils;

import lombok.extern.slf4j.Slf4j;

import java.io.File;

@Slf4j
public class FileUtils {
    public static boolean deleteFile(File file) {
        boolean deleted;
        try {
            deleted = file.delete();
        } catch (Exception ex) {
            log.error("Error deleting file {}", file.getAbsolutePath(), ex);
            return false;
        }

        if (!deleted) {
            log.warn("Error deleting file {}", file.getAbsolutePath());
            return false;
        }
        return true;
    }
}