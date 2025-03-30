package me.jmarango.productscrud.image.validators;

import com.sksamuel.scrimage.ImmutableImage;
import lombok.RequiredArgsConstructor;
import me.jmarango.productscrud.image.ImageValidationException;

@RequiredArgsConstructor
public class AspectRatio implements ImageValidator {

    private final Type type;

    @Override
    public void validate(ImmutableImage image) throws ImageValidationException {
        if (image.width / image.height != type.width / type.height) {
            throw new ImageValidationException("Invalid aspect ratio");
        }
    }

    public enum Type {
        SQUARE(1, 1),
        LANDSCAPE(16, 9);

        private final int width, height;

        Type(int width, int height) {
            this.width = width;
            this.height = height;
        }
    }
}
