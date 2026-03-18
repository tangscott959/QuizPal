# Database and Code Implementation Guide

## Step 1: Backup Current Database
```sql
-- Create a backup of your current database
mysqldump -u root -p mydb > mydb_backup.sql
```

## Step 2: Run Migration Script
Execute the `database_migration.sql` script to add missing columns:

```bash
mysql -u root -p mydb < database_migration.sql
```

This script:
- Adds missing columns to existing tables (status, timestamps, etc.)
- Creates the new `quiz_answer` table
- Adds foreign key constraints
- Uses `IF NOT EXISTS` to avoid errors if columns already exist

## Step 3: Create Views
Execute the `create_views.sql` script:

```bash
mysql -u root -p mydb < create_views.sql
```

This creates:
- `quiz_results_view` - for the new schema
- `question_stats_view` - for question analytics
- `quiz_results_legacy_view` - for backward compatibility

## Step 4: Update Application Configuration

### 4.1 Add Password Encoder Bean
Create or update `src/main/java/com/example/quiz_project/config/SecurityConfig.java`:

```java
package com.example.quiz_project.config;

import com.example.quiz_project.util.SimplePasswordEncoder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SecurityConfig {
    
    @Bean
    public SimplePasswordEncoder passwordEncoder() {
        return new SimplePasswordEncoder();
    }
}
```

### 4.2 Update Database Configuration
Update `src/main/resources/application.properties`:

```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=Txx12345
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate Configuration
spring.jpa.hibernate.ddl-auto=none
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect

# View Configuration
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
```

## Step 5: Gradual Code Migration

### Phase 1: Keep Existing Code Working
- Your existing code will continue to work with the migrated database
- The `quiz_results_legacy_view` provides backward compatibility

### Phase 2: Implement Improved Services
1. Add the new domain models in `domain/improved/` package
2. Add the new DAO classes in `dao/improved/` package  
3. Add the new service classes in `service/improved/` package
4. Add the new controllers in `controller/improved/` package

### Phase 3: Update Existing Controllers
Gradually replace existing service calls with improved versions:

```java
// Old approach
@Autowired
private UserService userService;

// New approach  
@Autowired
private UserServiceImproved userServiceImproved;
```

## Step 6: Password Migration

### 6.1 Create Password Migration Script
```sql
-- Create a script to migrate existing passwords to hashed format
-- This should be done through the application, not directly in SQL

-- First, add a temporary column for hashed passwords
ALTER TABLE user ADD COLUMN temp_password VARCHAR(255);

-- Then run through application to hash existing passwords
-- Update each user record with hashed password
```

### 6.2 Password Migration Utility
Create a utility class to migrate existing passwords:

```java
@Component
public class PasswordMigrationUtil {
    
    @Autowired
    private SimplePasswordEncoder passwordEncoder;
    
    @Autowired
    private UserDao userDao;
    
    public void migratePasswords() {
        List<User> users = userDao.getAllUsers();
        for (User user : users) {
            if (!user.getPassword().startsWith("$") || user.getPassword().length() < 50) {
                // Plain text password, hash it
                String hashedPassword = passwordEncoder.encode(user.getPassword());
                userDao.updatePassword(user.getUserId(), hashedPassword);
            }
        }
    }
}
```

## Step 7: Testing

### 7.1 Database Tests
```sql
-- Test the new views
SELECT * FROM quiz_results_view LIMIT 10;
SELECT * FROM question_stats_view LIMIT 10;
SELECT * FROM quiz_results_legacy_view LIMIT 10;
```

### 7.2 Application Tests
- Test user login with existing credentials
- Test quiz creation and completion
- Test admin functionality
- Test new features (time limits, question types)

## Step 8: Cleanup (Optional)

After confirming everything works:

1. Drop the old `quizquestion` table (if no longer needed):
```sql
DROP TABLE IF EXISTS quizquestion;
```

2. Remove legacy view:
```sql
DROP VIEW IF EXISTS quiz_results_legacy_view;
```

## Troubleshooting

### Common Issues:

1. **"Unknown column 'q.status'" error**
   - Solution: Run the migration script first

2. **Password authentication fails after migration**
   - Solution: Ensure password migration is completed
   - Temporary: Keep plain text passwords until migration is done

3. **Foreign key constraint errors**
   - Solution: Check data integrity before adding constraints
   - May need to clean up orphaned records

4. **Time zone issues with timestamps**
   - Solution: Configure MySQL timezone and application timezone

### Rollback Plan
If issues occur:
1. Restore from backup: `mysql -u root -p mydb < mydb_backup.sql`
2. Revert code changes
3. Identify and fix the specific issue
4. Re-run migration with fixes

## Benefits After Implementation

1. **Security**: Hashed passwords, proper authentication
2. **Performance**: Optimized queries, proper indexing
3. **Maintainability**: Clean code structure, proper error handling
4. **Features**: Time limits, question types, detailed analytics
5. **Data Integrity**: Proper constraints, cascading deletes

## Next Steps

1. Implement the remaining improved service classes
2. Add comprehensive validation
3. Implement proper error handling
4. Add logging and monitoring
5. Create unit and integration tests
6. Consider adding Spring Security for comprehensive security
