package com.khubeev.controller;

import com.khubeev.dto.NoteDto;
import com.khubeev.service.NoteService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminViewController {

    private final NoteService noteService;

    public AdminViewController(NoteService noteService) {
        this.noteService = noteService;
    }

    @GetMapping("/notes")
    public String getAllNotes(Model model) {
        List<NoteDto> notes = noteService.findAllNotesForAdmin();
        model.addAttribute("notes", notes);
        return "admin_notes";
    }

    @PostMapping("/notes/{id}/delete")
    public String deleteNote(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            noteService.deleteNoteByAdmin(id);
            redirectAttributes.addFlashAttribute("success", "Note deleted successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/notes";
    }
}