package com.khubeev.repository;

import com.khubeev.model.Note;
import com.khubeev.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {

    List<Note> findByAuthor(User author);

    List<Note> findByIsPublicTrue();

    @Query("SELECT n FROM Note n WHERE n.author = :author ORDER BY n.createdAt DESC")
    List<Note> findByAuthorOrderByCreatedAtDesc(@Param("author") User author);

    @Query("SELECT n FROM Note n WHERE n.isPublic = true ORDER BY n.createdAt DESC")
    List<Note> findAllPublicNotesOrderByCreatedAtDesc();

    @Query("SELECT n FROM Note n ORDER BY n.createdAt DESC")
    List<Note> findAllOrderByCreatedAtDesc();
}