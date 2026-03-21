package com.khubeev.service;

import com.khubeev.dto.NoteDto;
import com.khubeev.model.Note;
import com.khubeev.model.User;
import com.khubeev.repository.NoteRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(value = "jpaTransactionManager")
public class NoteService {

    private final NoteRepository noteRepository;

    public NoteService(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    private NoteDto convertToDto(Note note) {
        if (note == null) {
            return null;
        }
        return new NoteDto(
                note.getId(),
                note.getTitle(),
                note.getContent(),
                note.getCreatedAt(),
                note.isPublic(),
                note.getAuthor().getUsername()
        );
    }

    private void checkOwnership(Note note, User user) {
        if (!note.getAuthor().getId().equals(user.getId())) {
            throw new AccessDeniedException("You don't have permission to modify this note");
        }
    }

    @Transactional(value = "jpaTransactionManager", readOnly = true)
    public List<NoteDto> findAllByUser(User user) {
        if (user == null) {
            return List.of();
        }
        return noteRepository.findByAuthorOrderByCreatedAtDesc(user)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Transactional(value = "jpaTransactionManager", readOnly = true)
    public List<NoteDto> findAllPublicNotes() {
        return noteRepository.findAllPublicNotesOrderByCreatedAtDesc()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Transactional(value = "jpaTransactionManager", readOnly = true)
    public List<NoteDto> findAllNotesForAdmin() {
        List<Note> allNotes = noteRepository.findAll();
        return allNotes.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Transactional(value = "jpaTransactionManager")
    public NoteDto createNote(User user, String title, String content, boolean isPublic) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be empty");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Content cannot be empty");
        }
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }

        Note note = new Note(title, content, isPublic, user);
        Note savedNote = noteRepository.save(note);
        return convertToDto(savedNote);
    }

    @Transactional(value = "jpaTransactionManager")
    public NoteDto updateNote(Long noteId, User user, String title, String content, boolean isPublic) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found with id: " + noteId));

        checkOwnership(note, user);

        if (title != null && !title.trim().isEmpty()) {
            note.setTitle(title);
        }
        if (content != null) {
            note.setContent(content);
        }
        note.setPublic(isPublic);

        Note updatedNote = noteRepository.save(note);
        return convertToDto(updatedNote);
    }

    @Transactional(value = "jpaTransactionManager")
    public void deleteNote(Long noteId, User user) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found with id: " + noteId));

        checkOwnership(note, user);
        noteRepository.delete(note);
    }

    @Transactional(value = "jpaTransactionManager")
    public NoteDto deleteNoteByAdmin(Long noteId) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found with id: " + noteId));

        noteRepository.delete(note);
        return convertToDto(note);
    }

    @Transactional(value = "jpaTransactionManager", readOnly = true)
    public NoteDto findNoteByIdForEdit(Long noteId, User user) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found with id: " + noteId));

        checkOwnership(note, user);
        return convertToDto(note);
    }
}