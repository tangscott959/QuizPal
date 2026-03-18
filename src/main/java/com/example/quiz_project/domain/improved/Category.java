package com.example.quiz_project.domain.improved;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Category {
    private Integer categoryId;
    private String categoryName;
    private String description;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public boolean isActiveCategory() {
        return isActive != null && isActive;
    }

    public String getDisplayName() {
        return categoryName != null ? categoryName : "Unknown Category";
    }

    public boolean hasDescription() {
        return description != null && !description.trim().isEmpty();
    }
}
