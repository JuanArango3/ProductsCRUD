package me.jmarango.productscrud.image.validators;

import com.sksamuel.scrimage.ImmutableImage;
import me.jmarango.productscrud.image.ImageValidationException;

public interface ImageValidator {
    void validate(ImmutableImage image) throws ImageValidationException;
}
