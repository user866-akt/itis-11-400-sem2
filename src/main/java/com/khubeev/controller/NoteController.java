package com.khubeev.controller;

import com.khubeev.dto.NoteDto;
import com.khubeev.model.User;
import com.khubeev.service.CustomUserDetails;
import com.khubeev.service.NoteService;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/notes")
public class NoteController {

    private final NoteService noteService;

    public NoteController(NoteService noteService) {
        this.noteService = noteService;
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            return userDetails.getUser();
        }
        throw new IllegalStateException("User not authenticated");
    }

    @GetMapping
    public String myNotes(Model model) {
        User currentUser = getCurrentUser();
        model.addAttribute("notes", noteService.findAllByUser(currentUser));
        return "notes";
    }

    @GetMapping("/public")
    public String publicNotes(Model model) {
        model.addAttribute("notes", noteService.findAllPublicNotes());
        return "public_notes";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("note", new NoteDto());
        model.addAttribute("isEdit", false);
        return "note_form";
    }

    @PostMapping("/create")
    public String createNote(@RequestParam("title") String title,
                             @RequestParam("content") String content,
                             @RequestParam(value = "isPublic", defaultValue = "false") boolean isPublic,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = getCurrentUser();
            noteService.createNote(currentUser, title, content, isPublic);
            redirectAttributes.addFlashAttribute("success", "Note created successfully!");
            return "redirect:/notes";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/notes/create";
        }
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            User currentUser = getCurrentUser();
            NoteDto note = noteService.findNoteByIdForEdit(id, currentUser);

            if (note == null) {
                redirectAttributes.addFlashAttribute("error", "Note not found");
                return "redirect:/notes";
            }

            model.addAttribute("note", note);
            model.addAttribute("isEdit", true);
            return "note_form";
        } catch (AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/notes";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/notes";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateNote(@PathVariable("id") Long id,
                             @RequestParam("title") String title,
                             @RequestParam("content") String content,
                             @RequestParam(value = "isPublic", defaultValue = "false") boolean isPublic,
                             RedirectAttributes redirectAttributes) {
        try {
            User currentUser = getCurrentUser();
            noteService.updateNote(id, currentUser, title, content, isPublic);
            redirectAttributes.addFlashAttribute("success", "Note updated successfully!");
            return "redirect:/notes";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/notes/" + id + "/edit";
        }
    }

    @PostMapping("/{id}/delete")
    public String deleteNote(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            User currentUser = getCurrentUser();
            noteService.deleteNote(id, currentUser);
            redirectAttributes.addFlashAttribute("success", "Note deleted successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/notes";
    }
}